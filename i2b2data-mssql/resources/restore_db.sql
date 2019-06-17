use master

CREATE LOGIN i2b2pm WITH PASSWORD = 'demouser', CHECK_POLICY=off;
CREATE LOGIN i2b2demodata WITH PASSWORD = 'demouser', CHECK_POLICY=off;

RESTORE DATABASE i2b2pm FROM DISK = '/opt/i2b2pm.bak'
RESTORE DATABASE i2b2demodata FROM DISK = '/opt/i2b2demodata.bak'

UPDATE i2b2pm.dbo.pm_cell_data 
  SET url = 'http://$(i2b2_HOST):$(JBOSS_PORT)/i2b2/services/QueryToolService/' WHERE cell_id = 'CRC';
UPDATE i2b2pm.dbo.pm_cell_data
  SET url = 'http://$(i2b2_HOST):$(JBOSS_PORT)/i2b2/services/OntologyService/' WHERE cell_id = 'ONT';
UPDATE i2b2pm.dbo.pm_cell_data
  SET url = 'http://$(i2b2_HOST):$(JBOSS_PORT)/i2b2/services/WorkplaceService/' WHERE cell_id = 'WORK';
UPDATE i2b2pm.dbo.pm_cell_data
  SET url = 'http://$(i2b2_HOST):$(JBOSS_PORT)/i2b2/services/IMService/' WHERE cell_id = 'IM';
UPDATE i2b2pm.dbo.pm_cell_data
  SET url = 'http://$(i2b2_HOST):$(JBOSS_PORT)/i2b2/services/FRService/' WHERE cell_id = 'FRC';