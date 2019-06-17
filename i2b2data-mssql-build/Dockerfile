FROM microsoft/mssql-server-linux:latest

LABEL maintainer="Victor Castro <vcastro@partners.org>"

ARG i2b2_VERSION=1.7.11.0001
ENV i2b2_VERSION=${i2b2_VERSION}


RUN set -ex \
	\
	&& apt-get update && apt-get install -y \
		wget \
		ant \
        openjdk-8-jdk
    
RUN wget -O i2b2data.tar.gz "https://github.com/i2b2/i2b2-data/archive/v${i2b2_VERSION}.tar.gz" \
    && mkdir -p /opt/i2b2data \
	&& tar \
		--extract \
		--file i2b2data.tar.gz \
		--directory /opt/i2b2data \
        --strip-components 1 \
	&& rm i2b2data.tar.gz \
    && chmod -R 777 /opt/i2b2data \
	&& mkdir /docker-entrypoint-initdb.d/

ENV i2b2_DATA  "/opt/i2b2data/edu.harvard.i2b2.data/Release_1-7/NewInstall"

COPY config/*.conf /docker-entrypoint-initdb.d/
COPY resources/*.sh /docker-entrypoint-initdb.d/
COPY resources/*.sql /docker-entrypoint-initdb.d/

CMD /bin/bash /docker-entrypoint-initdb.d/entrypoint.sh