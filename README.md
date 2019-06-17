# i2b2 Docker #

The i2b2 stack on docker using the latest released i2b2 software from Github.  Includes containers for deploying to postrges (pg) or Microsoft sql server (mssql). Oracle is coming soon.  

Each DB has 2 containers: one for building the database from the i2b2-data scripts and a separate container for restoring and running the database.

This work is my initial attempt at learning the Docker ecosystem and having a fully contained i2b2 deployment across any database for development use.