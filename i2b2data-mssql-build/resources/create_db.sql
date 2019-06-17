use master

create database i2b2demodata;
create database i2b2pm;

CREATE LOGIN i2b2pm WITH PASSWORD = 'demouser', CHECK_POLICY=off;
CREATE LOGIN i2b2demodata WITH PASSWORD = 'demouser', CHECK_POLICY=off;
GO

use i2b2pm
GO

CREATE USER i2b2pm FROM LOGIN i2b2pm;
exec sp_addrolemember 'db_owner', 'i2b2pm';
GO

use i2b2demodata
GO

CREATE USER i2b2demodata FROM LOGIN i2b2demodata;
exec sp_addrolemember 'db_owner', 'i2b2demodata';
GO
