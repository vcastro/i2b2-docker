#!/usr/bin/env bash		
sleep 30s

cd /docker-entrypoint-initdb.d/

# creat database and users
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Yukon900 -d master -i create_db.sql

# config_properties
./config_db_properties.sh

# load data
./load_data.sh

# backup databases
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Yukon900 -d master -i backup_db.sql

cd /opt/i2b2data/
tar -czvf i2b2data-mssql.tar.gz *.bak
