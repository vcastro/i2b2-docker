FROM php:7.3.3-apache

LABEL maintainer = "Victor Castro <vcastro@partners.org>"

ARG i2b2_VERSION=1.7.11.0001

ARG JBOSS_PORT=8080
ARG i2b2_HOST=i2b2-server
ARG HIVE_ID=i2b2demo
ARG HIVE_NAME=i2b2demo


ENV i2b2_VERSION=${i2b2_VERSION}

RUN set -ex \
	\
	&& apt-get update && apt-get install -y \
		wget

#https://github.com/i2b2/i2b2-webclient/archive/v1.7.11.0001.tar.gz

RUN wget -O i2b2-webclient.tar.gz -nv "https://github.com/i2b2/i2b2-webclient/archive/v${i2b2_VERSION}.tar.gz" \
    && mkdir -p /opt/i2b2-webclient \
	&& tar \
		--extract \
		--file i2b2-webclient.tar.gz \
		--directory /var/www/html/ \
        --strip-components 1 \
	&& rm i2b2-webclient.tar.gz


WORKDIR /var/www/html

# Configuration
RUN sed -i "s#urlCellPM:.*#urlCellPM: 'http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/PMService/',#g" i2b2_config_data.js

# Configurtion: Standards
RUN sed -i "s#urlProxy:.*#urlProxy: 'index.php',#g" i2b2_config_data.js \
  && sed -i "s#urlFramework:.*#urlFramework: 'js-i2b2/',#g" i2b2_config_data.js \
  && sed -i "s/domain:.*/domain: '$HIVE_ID',/g" i2b2_config_data.js \
  && sed -i "s/name:.*/name: '$HIVE_NAME',/g" i2b2_config_data.js \
  && sed -i "s/debug:.*/debug: true/g" i2b2_config_data.js

# Configure Security in PHP Proxy
RUN sed -i "s/127.0.0.1/$i2b2_HOST/g" index.php \
  && sed -i "s/9090/$JBOSS_PORT/g" index.php \
  && sed -i 's#$pmURL = .*#$pmURL = "http://$i2b2_HOST:$JBOSS_PORT/i2b2/services/PMService/getServices";#g' index.php
