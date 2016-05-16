function    name = getPublishedBrains()

%%  PORTAL DB query
javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connPortalDB  = database('mbaDB','portal','admin','com.mysql.jdbc.Driver','jdbc:mysql://143.48.220.13:3306/mbaDB');
%fetch(exec(connPortalDB, ['describe ' 'seriesbrowser_series']))

qry_str = ['SELECT brain_id FROM seriesbrowser_series WHERE isReviewed LIKE TRUE AND isRestricted LIKE FALSE AND isAuxiliary LIKE FALSE AND keepForAnalysis LIKE FALSE ORDER BY brain_id ASC'];
data_query = fetch(exec(connPortalDB, qry_str));
u=data_query.Data(:,1);
brain_ids = unique([u{:}]');
nbrn = numel(brain_ids);

clear name;
for i=1:nbrn
    qry_str = ['SELECT name FROM seriesbrowser_brain WHERE id LIKE ''' int2str(brain_ids(i)) ''''];
    data_query = fetch(exec(connPortalDB, qry_str));
    a = sscanf(data_query.Data{1},'MouseBrain_%s');
    % Published brains' naming convention MouseBrain_[PRJ]****
    % where the 3-char projectID, PRJ, is omitted for PMD only.
    if ~isempty(str2num(a))
        a = ['PMD' int2str(sscanf(a,'%d'))];
    end;
    name{i}=a;
end;

close(connPortalDB);