
function   [injNo0, ara_id0, x0, y0, z0] = getInjLoc(injectionNumber)

javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connStorage = database('MBAStorageDB','root','admin','com.mysql.jdbc.Driver','jdbc:mysql://mitramba1.cshl.edu:3306/MBAStorageDB');

qry_str = ['SELECT number FROM Navigator_injectionlocation'];
data_query = fetch(exec(connStorage, qry_str));
u = data_query.Data;
injNo = [u{:,1}];
nInj = numel(injNo);

if nargin < 1
    ii0 = [1:nInj];
elseif nargin == 1
    ii0 = find(ismember(injectionNumber,injNo));
    
   if isempty(ii0) 
       fprintf(1,'getInjLoc Error:  Must supply a valid injectionNumber, within the range [%d...%d]\n',injNo([1 end]));
       injNo0 = injectionNumber;
       ara_id0 = {};
       x0 = [];
       y0 = [];
       z0 = [];
       return;
   end;
end;
nget = numel(ii0);

for i=1:nget
    injNo2get = injectionNumber(ii0(i));
    qry_str1 = ['SELECT number, ara_id, x, y, z FROM Navigator_injectionlocation WHERE number LIKE ''' int2str(injNo2get) ''''];
    data_query1 = fetch(exec(connStorage, qry_str1));
    u = data_query1.Data;
    injNo0(i) = u{1,1};
    ara_id0{i} = u{1,2};
    x0(i) = u{1,3};
    y0(i) = u{1,4};
    z0(i) = u{1,5};
    clear data_query1;
end;

close(connStorage);
