FROM jboss/wildfly:14.0.1.Final

LABEL maintainer = "Victor Castro <vcastro@partners.org>"

ARG i2b2_VERSION=1.7.11.0001
ARG AXIS_VERSION=1.7.1

ENV i2b2_VERSION=${i2b2_VERSION} \
    AXIS_VERSION=${AXIS_VERSION} \
    AXIS_FILE=axis2-$AXIS_VERSION-war.zip

ARG DB_HOST=i2b2data-pg
ARG JBOSS_PORT=8080

ENV \
  CON_URL=jdbc:postgresql://$DB_HOST:5432/i2b2 \
  DB_DRIVER_CLASS=org.postgresql.Driver \
  DB_DRIVER=postgresql-42.2.5.jar \
  \
  i2b2_db_user_HIVE=i2b2hive \
  i2b2_db_pass_HIVE=demouser \
  i2b2_db_schema_HIVE=i2b2hive \
  \
  i2b2_db_user_PM=i2b2pm \
  i2b2_db_pass_PM=demouser \
  i2b2_db_schema_PM=i2b2pm \
  \
  i2b2_AGGSERVICE_user=AGG_SERVICE_ACCOUNT \
  i2b2_AGGSERVICE_pass=demouser \
  \
  db_project=demo \
  \
  i2b2_db_user_CRC=i2b2demodata \
  i2b2_db_pass_CRC=demouser \
  i2b2_db_schema_CRC=i2b2demodata \
  \
  i2b2_db_user_ONT=i2b2metadata \
  i2b2_db_pass_ONT=demouser \
  i2b2_db_schema_ONT=i2b2metadata \
  \
  i2b2_db_user_WORK=i2b2workdata \
  i2b2_db_pass_WORK=demouser \
  i2b2_db_schema_WORK=i2b2workdata \
  \
  i2b2_db_user_IM=i2b2imdata \
  i2b2_db_pass_IM=demouser \
  i2b2_db_schema_IM=i2b2imdata

USER root

RUN yum -y install epel-release \
  && yum -y install ant wget xmlstarlet \
  && yum clean all

# Install Axis2
WORKDIR $JBOSS_HOME/standalone/deployments
RUN mkdir -p i2b2.war \
  && touch i2b2.war.dodeploy \
  \
  && cd /opt/ \
  && wget -nv https://www.i2b2.org/software/projects/installer/$AXIS_FILE \
  && unzip -q $AXIS_FILE -d axis2 \
  && unzip -q axis2/axis2.war -d $JBOSS_HOME/standalone/deployments/i2b2.war/ \
  && rm -r /opt/axis2 \
  && rm $AXIS_FILE 

RUN wget -O i2b2server.tar.gz -nv "https://github.com/i2b2/i2b2-core-server/archive/v${i2b2_VERSION}.tar.gz" \
    && mkdir -p /opt/i2b2-core-server \
	&& tar \
		--extract \
		--file i2b2server.tar.gz \
		--directory /opt/i2b2-core-server \
        --strip-components 1 \
	&& rm i2b2server.tar.gz


### server-common
WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.server-common
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
  \
  && ant clean dist deploy jboss_pre_deployment_setup


### PM
WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.pm
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure DB
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.pm/etc/jboss \
  && mv pm-ds.xml pm-ds.xml.orig && \
  XML_SCHEMA="ds=http://www.jboss.org/ironjacamar/schema" && \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:connection-url" -v $CON_URL pm-ds.xml.orig | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver-class" -v $DB_DRIVER_CLASS | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver" -v $DB_DRIVER | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:user-name" -v $i2b2_db_user_PM | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:password" -v $i2b2_db_pass_PM \
  > pm-ds.xml \
  && rm pm-ds.xml.orig \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.pm \
  && ant -f master_build.xml clean build-all deploy


### ONT

WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.ontology
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure Cells
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.ontology/etc/spring/ \
  && sed -i "s#applicationdir=.*#applicationdir=$JBOSS_HOME/standalone/configuration/ontologyapp#g" ontology_application_directory.properties \
  \
  && sed -i "s/ontology.bootstrapdb.metadataschema=.*/ontology.bootstrapdb.metadataschema=$i2b2_db_schema_HIVE/g" ontology.properties \
  && sed -i "s#http://localhost:9090#http://localhost:$JBOSS_PORT#g" ontology.properties \
  && sed -i "s/edu.harvard.i2b2.ontology.pm.serviceaccount.user=.*/edu.harvard.i2b2.ontology.pm.serviceaccount.user=$i2b2_AGGSERVICE_user/g" ontology.properties \
  && sed -i "s/edu.harvard.i2b2.ontology.pm.serviceaccount.password=.*/edu.harvard.i2b2.ontology.pm.serviceaccount.password=$i2b2_AGGSERVICE_pass/g" ontology.properties \
  && sed -i "s/Ontology.terminal.delimiter=.*/Ontology.terminal.delimiter=true/g" ontology.properties \
\
# Configure DB
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.ontology/etc/jboss \
  && mv ont-ds.xml ont-ds.xml.orig && \
  XML_SCHEMA="ds=http://www.jboss.org/ironjacamar/schema" && \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:connection-url" -v $CON_URL ont-ds.xml.orig | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver-class" -v $DB_DRIVER_CLASS | \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver" -v $DB_DRIVER | \
  xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[1]" -v $i2b2_db_user_ONT | \
  xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[1]" -v $i2b2_db_pass_ONT | \
  xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[2]" -v  $i2b2_db_user_HIVE | \
  xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[2]" -v $i2b2_db_pass_HIVE \
  > ont-ds.xml \
  && rm ont-ds.xml.orig \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.ontology \
  && ant -f master_build.xml clean build-all deploy


### CRC

WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.crc
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure Cells
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.crc/etc/spring/ \
  && sed -i "s#applicationdir=.*#applicationdir=$JBOSS_HOME/standalone/configuration/crcapp#g" crc_application_directory.properties \
  && sed -i "s#http://localhost:9090#http://localhost:$JBOSS_PORT#g" edu.harvard.i2b2.crc.loader.properties \
\
  && mv CRCLoaderApplicationContext.xml CRCLoaderApplicationContext.xml.orig && \
  xmlstarlet ed -u '//property[@name="driverClassName"]/@value' -v $DB_DRIVER_CLASS CRCLoaderApplicationContext.xml.orig | \
  xmlstarlet ed -u '//property[@name="url"]/@value' -v $CON_URL | \
  xmlstarlet ed -u '//property[@name="username"]/@value' -v $i2b2_db_user_HIVE | \
  xmlstarlet ed -u '//property[@name="password"]/@value' -v $i2b2_db_pass_HIVE \
  > CRCLoaderApplicationContext.xml \
  && rm CRCLoaderApplicationContext.xml.orig \
\
  && sed -i "s/edu.harvard.i2b2.crc.loader.ds.lookup.servertype=.*/edu.harvard.i2b2.crc.loader.ds.lookup.servertype=PostgreSQL/g" edu.harvard.i2b2.crc.loader.properties \
  && sed -i "s#http://localhost:9090#http://i2b2-server:$JBOSS_PORT#g" crc.properties \
  && sed -i "s/queryprocessor.ds.lookup.servertype=.*/queryprocessor.ds.lookup.servertype=PostgreSQL/g" crc.properties \
\
# Configure DB
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.crc/etc/jboss \
  && mv crc-ds.xml crc-ds.xml.orig && \
  XML_SCHEMA="ds=http://www.jboss.org/ironjacamar/schema" && \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:connection-url" -v $CON_URL crc-ds.xml.orig | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver-class" -v $DB_DRIVER_CLASS | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver" -v $DB_DRIVER | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[1]" -v $i2b2_db_user_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[1]" -v $i2b2_db_pass_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[2]" -v $i2b2_db_user_CRC | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[2]" -v $i2b2_db_pass_CRC \
  > crc-ds.xml \
  && rm crc-ds.xml.orig \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.crc \
  && ant -f master_build.xml clean build-all deploy


### WORK

WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.workplace
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure Cells
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.workplace/etc/spring/ \
  && sed -i "s#applicationdir=.*#applicationdir=$JBOSS_HOME/standalone/configuration/workplaceapp#g" workplace_application_directory.properties \
  && sed -i "s#http://localhost:9090#http://localhost:$JBOSS_PORT#g" workplace.properties \
  && sed -i "s/workplace.bootstrapdb.metadataschema=.*/workplace.bootstrapdb.metadataschema=$i2b2_db_schema_HIVE/g" workplace.properties \
\
# Configure DB
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.workplace/etc/jboss \
  && mv work-ds.xml work-ds.xml.orig && \
  XML_SCHEMA="ds=http://www.jboss.org/ironjacamar/schema" && \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:connection-url" -v $CON_URL work-ds.xml.orig | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver-class" -v $DB_DRIVER_CLASS | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver" -v $DB_DRIVER | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[1]" -v $i2b2_db_user_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[1]" -v $i2b2_db_pass_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[2]" -v $i2b2_db_user_WORK | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[2]" -v $i2b2_db_pass_WORK \
  > work-ds.xml \
  && rm work-ds.xml.orig \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.workplace \
  && ant -f master_build.xml clean build-all deploy



### FR

WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.fr
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure Cells
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.fr/etc/spring/ \
  && sed -i "s#applicationdir=.*#applicationdir=$JBOSS_HOME/standalone/configuration/frapp#g" fr_application_directory.properties \
  && sed -i "s#http://localhost:9090#http://localhost:$JBOSS_PORT#g" edu.harvard.i2b2.fr.properties \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.fr \
  && ant -f master_build.xml clean build-all deploy


### IM

WORKDIR /opt/i2b2-core-server/edu.harvard.i2b2.im
RUN sed -i "s#jboss.home=.*#jboss.home=$JBOSS_HOME#g" build.properties \
\
# Configure Cells
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.im/etc/spring/ \
  && sed -i "s#applicationdir=.*#applicationdir=$JBOSS_HOME/standalone/configuration/imapp#g" im_application_directory.properties \
  && sed -i "s#http://localhost:9090#http://localhost:$JBOSS_PORT#g" im.properties \
  && sed -i "s/im.checkPatientInProject=.*/im.checkPatientInProject=true/g" im.properties \
\
# Configure DB
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.im/etc/jboss \
  && mv im-ds.xml im-ds.xml.orig && \
  XML_SCHEMA="ds=http://www.jboss.org/ironjacamar/schema" && \
  xmlstarlet ed -N $XML_SCHEMA  -u "//ds:connection-url" -v $CON_URL im-ds.xml.orig | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver-class" -v $DB_DRIVER_CLASS | \
    xmlstarlet ed -N $XML_SCHEMA  -u "//ds:driver" -v $DB_DRIVER | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[1]" -v $i2b2_db_user_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[1]" -v $i2b2_db_pass_HIVE | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:user-name)[2]" -v $i2b2_db_user_IM | \
    xmlstarlet ed -N $XML_SCHEMA  -u "(//ds:password)[2]" -v $i2b2_d/optb_pass_IM \
  > im-ds.xml \
  && rm im-ds.xml.orig \
\
# Deploy Cell
  && cd /opt/i2b2-core-server/edu.harvard.i2b2.im \
  && ant -f master_build.xml clean build-all deploy \
\
  && rm -R /opt/i2b2-core-server