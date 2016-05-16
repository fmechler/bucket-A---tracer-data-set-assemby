function [DoubleInj, Inj1, Inj2]=getAAVDoubleInj_fromPortalNotes(brainName)
%%*************************************************************************
% run this script from Matlab 11 on mitragpu2
%   /usr/local/MATLAB/R2011a/bin/matlab

tic;
% connect to portal data base mbaDB via MySQL server
javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connPortalDB  = database('mbaDB','portal','admin','com.mysql.jdbc.Driver','jdbc:mysql://143.48.220.13:3306/mbaDB');
% connect to storage data base mbaDB via MySQL server
connStorage = database('MBAStorageDB','root','admin','com.mysql.jdbc.Driver','jdbc:mysql://mitramba1.cshl.edu:3306/MBAStorageDB');


%var_query = fetch(exec(connPortalDB, ['describe seriesbrowser_series']));
%vars = var_query.Data;

brainID=brainName;
if regexp(brainName,'PMD')==1
    brnID=brainName(4:end);
else
    brnID=brainName;
end;
%brnID='2300'
% get the 2nd injection for AAV brains from the notes field in the seriesbrowser_series table
brn_portalName = sprintf('MouseBrain_%s',brnID);
qry_str = ['SELECT id FROM seriesbrowser_brain WHERE name LIKE ''' brn_portalName ''''];
data_query = fetch(exec(connPortalDB, qry_str));
u=data_query.Data{1};

%qry_str = ['SELECT brain_id FROM seriesbrowser_series WHERE brain_id LIKE ''' int2str(u) ''''];
%qry_str = ['SELECT imageMethod_id FROM seriesbrowser_series WHERE brain_id LIKE ''' int2str(u) ''''];
qry_str = ['SELECT notes FROM seriesbrowser_series WHERE imageMethod_id LIKE 2 AND brain_id LIKE ''' int2str(u) ''''];
%qry_str = ['SELECT imageMethod_id FROM seriesbrowser_series WHERE brain_id LIKE ''' int2str(u) ''''];
data_query = fetch(exec(connPortalDB, qry_str));
notes_str=data_query.Data{:,1}

i1=regexp(notes_str,[char(10) 'RED']);
i2=regexp(notes_str,[char(10) 'GRN']);

if ~isempty(i1) & ~isempty(i2)
    if i1<i2
        inj1_str=notes_str([i1+4:i2-1]);
        inj2_str=notes_str([i2+4:end]);
    end;
    if i1>i2
        inj2_str=notes_str([i2+4:i1-1]);
        inj1_str=notes_str([i1+4:end]);
    end;
else
    inj1_str='';
    inj2_str='';
end;

% find the first characters for the space-separated (signed) numerical
% values of x y z expected as a group written at the end of both strings
ii1=regexp(inj1_str,'\s+\-?\d+');
ii2=regexp(inj2_str,'\s+\-?\d+');
n1=numel(ii1);
n2=numel(ii2);

% initialize the records for two injections with the default values
DoubleInj=0;
Inj1.trcr_clr='N/A';
Inj1.Ainj=NaN;
Inj1.x=NaN;
Inj1.y=NaN;
Inj1.z=NaN;
Inj1.ara='N/A';
Inj2=Inj1;

% proceed IFF a second injection is logged for this brain ...
if n1>=3 & n2>=3
    
    DoubleInj = 1;
    
    % parse parameters for RED injection
    Inj1.trcr_clr='R';
    Inj1.ara = sscanf(inj1_str(1:ii1(n1-2)-1),'%s\\');
    ubu1=sscanf(inj1_str(ii1(n1-2):end),'%d');
    Inj1.x=ubu1(1);
    Inj1.y=ubu1(2);
    Inj1.z=ubu1(3);
    % find correjsponding InjNo in Navigator_Injectionlocations
    qry_str1 = ['SELECT number FROM Navigator_injectionlocation WHERE x LIKE ''' int2str(Inj1.x) ''' AND y LIKE ''' int2str(Inj1.y) ''' AND z  LIKE ''' int2str(Inj1.z) ''''];
    data_query1 = fetch(exec(connStorage, qry_str1));
    u=data_query1.Data;
    Inj1.Ainj = u{1,1};
    clear data_query1;
    
    % parse parameters for GRN injection
    Inj2.trcr_clr='G';
    Inj2.ara = sscanf(inj2_str(1:ii2(n2-2)-1),'%s\\');
    ubu2=sscanf(inj2_str(ii2(n2-2):end),'%d');
    Inj2.x=ubu2(1);
    Inj2.y=ubu2(2);
    Inj2.z=ubu2(3);
    % find corresponding InjNo in Navigator_Injectionlocations
    qry_str2 = ['SELECT number FROM Navigator_injectionlocation WHERE x LIKE ''' int2str(Inj2.x) ''' AND y LIKE ''' int2str(Inj2.y) ''' AND z  LIKE ''' int2str(Inj2.z) ''''];
    data_query2 = fetch(exec(connStorage, qry_str2));
    u=data_query2.Data;
    Inj2.Ainj = u{1,1};
    clear data_query2;
end;

close(connStorage);
close(connPortalDB);