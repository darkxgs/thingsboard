#!/bin/bash
set -e

echo "Starting ThingsBoard initialization..."

# Memory optimization
export JAVA_OPTS="${JAVA_OPTS} -Dinstall.load_demo=false -Dspring.jpa.hibernate.ddl-auto=none -Dinstall.upgrade=false"

echo "Using Java options: $JAVA_OPTS"

# Wait for PostgreSQL to be ready
echo "Waiting for PostgreSQL to be ready..."
for i in {1..30}; do
  if pg_isready -h postgres -p 5432 -U postgres; then
    echo "PostgreSQL is ready!"
    break
  fi
  echo "PostgreSQL is not ready yet. Retrying in 2 seconds..."
  sleep 2
done

# Create database if it doesn't exist
echo "Ensuring database exists..."
PGPASSWORD=$SPRING_DATASOURCE_PASSWORD psql -h postgres -U postgres -c "CREATE DATABASE IF NOT EXISTS thingsboard"

# Run the initialization script
echo "Initializing ThingsBoard database..."
java -cp /usr/share/thingsboard/bin/thingsboard.jar $JAVA_OPTS \
  -Dloader.main=org.thingsboard.server.ThingsboardInstallApplication \
  -Dinstall.load_demo=false \
  -Dspring.jpa.hibernate.ddl-auto=none \
  -Dinstall.upgrade=false \
  org.springframework.boot.loader.launch.PropertiesLauncher

echo "Database initialization complete. Starting ThingsBoard..."
exec /usr/bin/start-tb.sh 