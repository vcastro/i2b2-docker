FROM microsoft/mssql-server-linux:latest

LABEL maintainer="Victor Castro <vcastro@partners.org>"


ARG JBOSS_PORT=8080
ENV JBOSS_PORT=${JBOSS_PORT}

ARG i2b2_HOST=i2b2-server
ENV i2b2_HOST=${i2b2_HOST}

ARG i2b2_VERSION=1.7.11.0001
ENV i2b2_VERSION=${i2b2_VERSION}

ADD i2b2data-mssql.tar.gz /opt/

COPY resources/* /

CMD /bin/bash ./entrypoint.sh