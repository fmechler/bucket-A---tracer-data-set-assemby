
function    mmID = getLIMS_mmID(projectCode,mouseCounter)

% return the MousemetadataID for say ('PMD',1556)  or ('Hua', 204)

javaaddpath('mysql-connector-java-5.1.20-bin.jar');
connLIMS = database('LIMS','Mitramba1DBUser','123456','com.mysql.jdbc.Driver','jdbc:mysql://mitramba1.cshl.edu:3306/LIMS');

ubu = fetch(exec(connLIMS, ['SELECT  id, mouseType, mouseTypeCounter FROM mousemetadatas WHERE mouseType like ''' projectCode ''' AND  mouseTypeCounter  like ' int2str(mouseCounter)]));

mmID = NaN;

if numel(ubu.Data)==3
    if strcmp(projectCode,ubu.Data{1,2}) & mouseCounter==ubu.Data{1,3}
        mmID = ubu.Data{1,1};
    end;
end

close(connLIMS);

if 0
    % table = 'mousemetadatas';
    % var_query = fetch(exec(connLIMS, ['describe ' table])); vars = var_query.Data
    % 'id'                   'int(11)'         'NO'     'PRI'    'null'        'auto_increment'
    % 'created_at'           'datetime'        'YES'    ''       'null'        ''              
    % 'updated_at'           'datetime'        'YES'    ''       'null'        ''              
    % 'DOB'                  'date'            'NO'     ''       'null'        ''              
    % 'arrivalDateAtCSHL'    'date'            'NO'     ''       'null'        ''              
    % 'sex'                  'varchar(255)'    'YES'    ''       [1x7 char]    ''              
    % 'weight'               'float'           'YES'    ''       'null'        ''              
    % 'species'              'varchar(255)'    'NO'     ''       'null'        ''              
    % 'earTag'               'int(11)'         'YES'    ''       'null'        ''              
    % 'mouseType'            'varchar(255)'    'YES'    ''       [1x9 char]    ''              
    % 'mouseTypeCounter'     'int(11)'         'YES'    ''       'null'        ''              
    % 'failed'               'tinyint(1)'      'YES'    ''       '0'           ''              
end;