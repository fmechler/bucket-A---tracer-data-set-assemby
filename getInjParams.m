
function    InjPar = getInjParams(brnIDs)
%%  STORAGE DB query
javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connStorage = database('MBAStorageDB','root','admin','com.mysql.jdbc.Driver','jdbc:mysql://mitramba1.cshl.edu:3306/MBAStorageDB');
nbrn = numel(brnIDs);
trcr_types={'AAV','BDA','CTB','RRV'};

for i=1:nbrn
    a=brnIDs{i};
    
    if mod(i,20)==0
        fprintf(1,'processig brain %s  (n=%d)\n',a,i);
    end;
    
    qry_str1 = ['SELECT name, ActualInjection, TargetInjection, isFinalized, isRegistered, onPortal, reInject, BiolQC, InjectionSection FROM Navigator_brain WHERE name LIKE ''' a ''''];
    data_query1 = fetch(exec(connStorage, qry_str1));
    u=data_query1.Data;
    InjPar.brnID{i}=u{1,1};
    InjPar.Ainj(i)=u{1,2};
    InjPar.Tinj(i)=u{1,3};
    InjPar.isFinalized(i)=u{4};
    InjPar.isRegistered(i)=u{5};
    InjPar.onPortal(i)=u{6};
    InjPar.reInject(i)=u{7}; 
    InjPar.BiolQC{i}=u{8};
    InjPar.InjSec(i)=u{9};
    
    flgs{i}=u(4:7);
    
    qry_str2 = ['SELECT tracer FROM Navigator_injection WHERE brain_id LIKE ''' a ''''];
    data_query2 = fetch(exec(connStorage, qry_str2));
    u=data_query2.Data;
    nu = numel(u);
    % assign a 3-char AND a numerical tracer_id (AAV==1  BDA==2 CTB==3  RRV==4)
    u1=regexp(u,'^AAV');
    u2=regexp(u,'^BDA');
    u3=regexp(u,'^CTB');
    u4a=regexp(u,'^Retr');
    u4b=regexp(u,'^RV-4r');
    if ~isempty([u1{:}]) tr_id(i)=1;                                 % AAV==1
    elseif ~isempty([u2{:}]) tr_id(i)=2;                             % BDA==2
    elseif ~isempty([u3{:}]) tr_id(i)=3;                             % CTB==3
    elseif ~isempty([u4a{:}]) | ~isempty([u4a{:}]) tr_id(i)=4;       % RRV==4
    else tr_id(i) = NaN;
    end;
    
    if isnan(tr_id(i))
        InjPar.trcr{i} = 'N/A';
    else
        InjPar.tr_id(i) = tr_id(i);
        InjPar.trcr{i}= trcr_types{tr_id(i)};
    end;
    
    if isnan(InjPar.Ainj(i))
        InjPar.ara_id{i} = 'Brain';
        InjPar.x(i) = NaN;
        InjPar.y(i) = NaN;
        InjPar.z(i) = NaN;
    else
        qry_str3 = ['SELECT ara_id, x, y, z FROM Navigator_injectionlocation WHERE number LIKE ''' int2str(InjPar.Ainj(i)) ''''];
        data_query3 = fetch(exec(connStorage, qry_str3));
        u=data_query3.Data;
        
        InjPar.ara_id{i} = u{1,1};
        InjPar.x(i) = u{1,2};
        InjPar.y(i) = u{1,3};
        InjPar.z(i) = u{1,4};
        clear data_query3;
    end;
end;

close(connStorage);
