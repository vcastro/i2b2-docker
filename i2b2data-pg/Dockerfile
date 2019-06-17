FROM postgres:11.2-alpine

LABEL maintainer = "Victor Castro <vcastro@partners.org>"

COPY i2b2dump.pgdata /docker-entrypoint-initdb.d/
COPY restore.sh /docker-entrypoint-initdb.d/
COPY user.config /docker-entrypoint-initdb.d/
