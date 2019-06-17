docker build --rm -f "i2b2data-pg-build\Dockerfile" -t i2b2data-pg-build:latest i2b2data-pg-build
docker run --rm --name i2b2pg-build -d i2b2data-pg-build
docker cp i2b2pg-build:/opt/i2b2data/i2b2dump.pgdata ../i2b2data-pg/i2b2dump.pgdata
