#! /bin/bash

source /docker-entrypoint-initdb.d/hive.conf
source /docker-entrypoint-initdb.d/project_i2b2demodata.conf

printf "\n\n"
echo $PG_VERSION
printf "\n\n"

pg_ctl stop -w

# PostgreSQL
echo "host all  all    0.0.0.0/0  md5" >> $PGDATA/pg_hba.conf
sed -i "s/#checkpoint_segments = 3/checkpoint_segments = 10/g" $PGDATA/postgresql.conf

# activate new settings
pg_ctl start -w

printf "\n"
echo "---------------------------------------------"
printf "CREATING SCHEMA & USER: START\n\n"

createdb i2b2

psql -a -U postgres --dbname=i2b2  <<EOSQL
CREATE USER $i2b2_db_user_HIVE 		  PASSWORD '$i2b2_db_pass_HIVE';
CREATE USER $i2b2_db_user_PM 		    PASSWORD '$i2b2_db_pass_PM';
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_HIVE;
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_PM;
CREATE USER $i2b2_db_user_CRC 	PASSWORD '$i2b2_db_pass_CRC'; -- CRC
CREATE USER $i2b2_db_user_ONT 	PASSWORD '$i2b2_db_pass_ONT'; -- ONT
CREATE USER $i2b2_db_user_WORK 	PASSWORD '$i2b2_db_pass_WORK'; -- WORK
CREATE USER $i2b2_db_user_IM 	PASSWORD '$i2b2_db_pass_IM'; -- IM
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_CRC;
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_ONT;
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_WORK;
CREATE SCHEMA IF NOT EXISTS AUTHORIZATION $i2b2_db_schema_IM;
EOSQL

printf "\nCREATING SCHEMA & USER: STOP\n"
echo "---------------------------------------------"
printf "\n"