
function   InjPar = getLIMS_InjPar(mmID)

% return the InjPar for mouse_metadata_id mmID

javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connLIMS = database('LIMS','Mitramba1DBUser','123456','com.mysql.jdbc.Driver','jdbc:mysql://mitramba1.cshl.edu:3306/LIMS');

InjPar0.injID = NaN;
InjPar0.injT = 'N/A       ';
InjPar0.trcrID = NaN;
InjPar0.Trcr = 'N/A       ';
InjPar0.x = NaN;
InjPar0.y = NaN;
InjPar0.z = NaN;
InjPar0.notes = 'N/A       ';
if ~isnan(mmID)
    ubu = fetch(exec(connLIMS, ['SELECT  id, injectionTime , tracer_type_id, xCoordinate , yCoordinate , zCoordinate, mousemetadata_id, notes FROM stereotaxic_injections WHERE mousemetadata_id LIKE ' int2str(mmID)]));
    [nInj, nDat] = size(ubu.Data);
    for iInj = 1:nInj
        InjPar(iInj)=InjPar0;
        if nDat==8
            if mmID==ubu.Data{iInj,7}
                InjPar(iInj).injID = ubu.Data{iInj,1};
                InjPar(iInj).injT = ubu.Data{iInj,2};
                InjPar(iInj).x = ubu.Data{iInj,4};
                InjPar(iInj).y = ubu.Data{iInj,5};
                InjPar(iInj).z = ubu.Data{iInj,6};
                InjPar(iInj).notes = ubu.Data{iInj,8};
                % get the tracerType
                if ~isnan(ubu.Data{iInj,3})
                    InjPar(iInj).trcrID = ubu.Data{iInj,3};
                    ubu1 = fetch(exec(connLIMS, ['SELECT  id, Description FROM tracer_types WHERE id LIKE ' int2str(InjPar(iInj).trcrID)]));
                    if InjPar(iInj).trcrID == ubu1.Data{1,1};
                        InjPar(iInj).Trcr=ubu1.Data{1,2};
                    end;
                end; % if ~isnan(ubu.Data{iInj,3})
            end; % if mmID==ubu.Data{iInj,7}
        end; % nDat==8
    end; % for iInj
end; % if ~isnan(mmID)

close(connLIMS);

if 0
    % table = 'stereotaxic_injections';
    % var_query = fetch(exec(connLIMS, ['describe ' table])); vars = var_query.Data
    %'id'                     'int(11)'         'NO'     'PRI'    'null'         'auto_increment'
    %'created_at'             'datetime'        'YES'    ''       'null'         ''              
    %'updated_at'             'datetime'        'YES'    ''       'null'         ''              
    %'injectionMethod'        'varchar(255)'    'YES'    ''       'null'         ''              
    %'injectionTime'          'datetime'        'YES'    ''       'null'         ''              
    %'tracerAmountLoaded'     'float'           'YES'    ''       'null'         ''              
    %'overallInjectionQuality' 'varchar(255)'    'YES'    ''       'null'         ''              
    %'outcomeAnimalHealth'    'varchar(255)'    'YES'    ''       [1x15 char]    ''              
    %'notes'                  'text'            'YES'    ''       'null'         ''              
    %'tracer_aliquot_id'      'int(11)'         'YES'    'MUL'    'null'         ''              
    %'mousemetadata_id'       'int(11)'         'YES'    'MUL'    'null'         ''              
    %'tracer_type_id'         'int(11)'         'YES'    'MUL'    'null'         ''              
    %'tracerAmountInjected'    'float'           'YES'    ''       'null'         ''              
    %'pipette_pull_id'        'int(11)'         'YES'    'MUL'    'null'         ''              
    %'tracer_batch_id'        'int(11)'         'YES'    'MUL'    'null'         ''              
    %'xCoordinate'            'float'           'YES'    ''       'null'         ''              
    %'yCoordinate'            'float'           'YES'    ''       'null'         ''              
    %'zCoordinate'            'float'           'YES'    ''       'null'         ''              
    %'alpha'                  'int(11)'         'YES'    ''       'null'         ''              
    %'injectionType'          'varchar(255)'    'YES'    ''       [1x11 char]    ''              
    %'injection_plan_id'      'int(11)'         'YES'    'MUL'    'null'         ''              
    %'locationTag'            'varchar(255)'    'YES'    ''       'null'         ''              

    % table = 'tracer_types';
    % var_query = fetch(exec(connLIMS, ['describe ' table])); vars = var_query.Data
    %'id'                   'int(11)'         'NO'     'PRI'    'null'    'auto_increment'
    %'Description'          'varchar(45)'     'NO'     ''       'null'    ''              
    %'created_at'           'datetime'        'YES'    ''       'null'    ''              
    %'updated_at'           'datetime'        'YES'    ''       'null'    ''              
    %'Manufacturer'         'varchar(45)'     'YES'    ''       'null'    ''              
    %'catalogueNumber'      'varchar(255)'    'YES'    ''       'null'    ''              
    %'stain_paradigm_id'    'int(11)'         'YES'    'MUL'    'null'    ''              
end;
