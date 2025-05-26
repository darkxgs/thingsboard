#!/bin/bash
set -e

# Configure PostgreSQL connection
if [[ -z "$SPRING_DATASOURCE_URL" ]]; then
  echo "ERROR: SPRING_DATASOURCE_URL is not set"
  exit 1
fi

# Extract connection details
if [[ $SPRING_DATASOURCE_URL == *"postgresql"* ]]; then
  echo "Using PostgreSQL database"
  
  # Initialize ThingsBoard with reduced memory settings
  export JAVA_OPTS="${JAVA_OPTS} -Dinstall.load_demo=false -Dspring.jpa.hibernate.ddl-auto=none -Dinstall.upgrade=false"
  
  # Run the initialization
  java -cp /usr/share/thingsboard/bin/thingsboard.jar $JAVA_OPTS \
    -Dloader.main=org.thingsboard.server.ThingsboardInstallApplication \
    org.springframework.boot.loader.launch.PropertiesLauncher
    
  # Start ThingsBoard
  echo "Starting ThingsBoard..."
  exec start-tb.sh
else
  echo "ERROR: Only PostgreSQL is supported"
  exit 1
fi 