#!/bin/bash

source /docker-entrypoint-initdb.d/user.config

file="/docker-entrypoint-initdb.d/i2b2dump.pgdata"
dbname=i2b2

createdb i2b2

psql -a -U postgres --dbname=i2b2  <<EOSQL
CREATE USER $i2b2_db_user_HIVE 		  PASSWORD '$i2b2_db_pass_HIVE';
CREATE USER $i2b2_db_user_PM 		    PASSWORD '$i2b2_db_pass_PM';
CREATE USER $i2b2_db_user_CRC 	PASSWORD '$i2b2_db_pass_CRC'; -- CRC
CREATE USER $i2b2_db_user_ONT 	PASSWORD '$i2b2_db_pass_ONT'; -- ONT
CREATE USER $i2b2_db_user_WORK 	PASSWORD '$i2b2_db_pass_WORK'; -- WORK
CREATE USER $i2b2_db_user_IM 	PASSWORD '$i2b2_db_pass_IM'; -- IM
EOSQL

echo "Restoring DB using $file"
pg_restore -U postgres --dbname=$dbname --verbose --single-transaction < "$file" || exit 1

printf "\n"
echo "---------------------------------------------"
printf "COMPLETED pg_restore of $file"

psql -a -U postgres --dbname=i2b2  <<EOSQL
UPDATE i2b2pm.pm_cell_data 
  SET url = 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/QueryToolService/' WHERE cell_id = 'CRC';
UPDATE i2b2pm.pm_cell_data
  SET url = 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/OntologyService/' WHERE cell_id = 'ONT';
UPDATE i2b2pm.pm_cell_data
  SET url = 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/WorkplaceService/' WHERE cell_id = 'WORK';
UPDATE i2b2pm.pm_cell_data
  SET url = 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/IMService/' WHERE cell_id = 'IM';
UPDATE i2b2pm.pm_cell_data
  SET url = 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/FRService/' WHERE cell_id = 'FRC';
EOSQL

#TODO: change schema name in pg-build