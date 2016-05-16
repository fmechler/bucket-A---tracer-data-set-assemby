function    name = getBrainsOnPortal(selection_string)

%%  PORTAL DB query
javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connPortalDB  = database('mbaDB','portal','admin','com.mysql.jdbc.Driver','jdbc:mysql://143.48.220.13:3306/mbaDB');
%fetch(exec(connPortalDB, ['describe ' 'seriesbrowser_series']))
switch selection_string
    case 'Published'
        query_selection_str = 'isReviewed LIKE TRUE AND isRestricted LIKE FALSE AND isAuxiliary LIKE FALSE AND keepForAnalysis LIKE FALSE';
    case 'KeepForAnal'
        query_selection_str = 'isRestricted LIKE TRUE AND isAuxiliary LIKE FALSE AND keepForAnalysis LIKE TRUE';
    case 'Collab'
        query_selection_str = 'isRestricted LIKE TRUE AND isAuxiliary LIKE FALSE AND keepForAnalysis LIKE FALSE';
end;
qry_str = ['SELECT brain_id FROM seriesbrowser_series WHERE ' query_selection_str ' ORDER BY brain_id ASC'];
data_query = fetch(exec(connPortalDB, qry_str));
u=data_query.Data(:,1);
brain_ids = unique([u{:}]');
nbrn = numel(brain_ids);

clear name;
i_empty=[];
for i=1:nbrn
    qry_str = ['SELECT name FROM seriesbrowser_brain WHERE id LIKE ''' int2str(brain_ids(i)) ''''];
    data_query = fetch(exec(connPortalDB, qry_str));
    a = sscanf(data_query.Data{1},'MouseBrain_%s');
    % Published brains' naming convention MouseBrain_[PRJ]****
    % where the 3-char projectID, PRJ, is omitted for PMD only.
    if ~isempty(str2num(a))
        a1 = ['PMD' int2str(sscanf(a,'%d'))];
    else
        a1=a;
    end;
    switch selection_string
        case 'Collab'
            % screen out MBA production or experimental brains - assumes what is left after that are all collab
            if ~any(strcmp({'PM','PT','MD'},a1(1:2))) & ~any(strcmp({'0','1','2','3'},a1(1)))
                name{i}=a1; 
            else
                i_empty=[i_empty; i];
            end;
        otherwise
            name{i}=a1;
    end;
end;
name(i_empty)=[];
close(connPortalDB);