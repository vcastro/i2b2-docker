sleep 20s

# create users and restore databases
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Yukon900 -d master -i restore_db.sql