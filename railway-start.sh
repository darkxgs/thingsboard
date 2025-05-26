#!/bin/sh
set -e

echo "Starting ThingsBoard with minimal settings..."
echo "Java options: $JAVA_OPTS"
echo "Database URL: $SPRING_DATASOURCE_URL"

# Initialize database if needed
if [ ! -f ${HSQLDB_DATA_DIR}/thingsboardDb.script ]; then
  echo "Initializing database..."
  java -Xms64m -Xmx128m $JAVA_OPTS \
    -Dspring.datasource.url=${SPRING_DATASOURCE_URL} \
    -Dspring.datasource.username=${SPRING_DATASOURCE_USERNAME} \
    -Dspring.datasource.password=${SPRING_DATASOURCE_PASSWORD} \
    -Dinstall.load_demo=false \
    -Dspring.jpa.hibernate.ddl-auto=create \
    -jar /thingsboard/tb.jar --install
  echo "Database initialization complete"
fi

# Start with minimal features enabled
echo "Starting ThingsBoard..."
exec java $JAVA_OPTS \
  -Dspring.datasource.url=${SPRING_DATASOURCE_URL} \
  -Dspring.datasource.username=${SPRING_DATASOURCE_USERNAME} \
  -Dspring.datasource.password=${SPRING_DATASOURCE_PASSWORD} \
  -Dspring.jpa.hibernate.ddl-auto=none \
  -Dinstall.upgrade=false \
  -Dui.help.base-url=https://thingsboard.io \
  -Dui.help.enabled=false \
  -Dservice.type=monolith \
  -Dui.dashboard.max-datapoints-limit=5000 \
  -Drule-engine.queues.usage-stats-interval-ms=600000 \
  -Dactors.system.throughput=5 \
  -jar /thingsboard/tb.jar 