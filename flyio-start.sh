#!/bin/bash
set -e

echo "Starting ThingsBoard on Fly.io..."

# Memory optimization
export JAVA_OPTS="${JAVA_OPTS} -Dinstall.load_demo=false"

# Use HSQLDB for minimal memory usage
export DATABASE_TS_TYPE=sql
export SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.HSQLDialect
export SPRING_DRIVER_CLASS_NAME=org.hsqldb.jdbc.JDBCDriver
export SPRING_DATASOURCE_URL=jdbc:hsqldb:file:${HSQLDB_DATA_DIR}/thingsboardDb;sql.enforce_size=false;hsqldb.log_size=5
export SPRING_DATASOURCE_USERNAME=sa
export SPRING_DATASOURCE_PASSWORD=

echo "Setting up HSQLDB database in ${HSQLDB_DATA_DIR}..."
mkdir -p ${HSQLDB_DATA_DIR}

# Check if the database has been initialized
if [ ! -f ${HSQLDB_DATA_DIR}/thingsboardDb.script ]; then
    echo "Initializing ThingsBoard database..."
    # Run with minimal memory settings
    java -Xms128m -Xmx256m -jar /usr/share/thingsboard/bin/thingsboard.jar \
        --loadDemo=false \
        -Dspring.jpa.hibernate.ddl-auto=none \
        -Dinstall.upgrade=false \
        -Dlogging.config=/usr/share/thingsboard/bin/install/logback.xml \
        --install
fi

echo "Starting ThingsBoard service..."
exec java ${JAVA_OPTS} -jar /usr/share/thingsboard/bin/thingsboard.jar 