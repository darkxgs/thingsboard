# Use a lightweight JDK base image
FROM eclipse-temurin:17-jre-alpine

# Set environment variables
ENV TB_QUEUE_TYPE=in-memory
ENV JAVA_OPTS="-Xms64m -Xmx256m -XX:+ExitOnOutOfMemoryError -XX:+UseG1GC -XX:MaxGCPauseMillis=20"
ENV TB_LOAD_DEMO=false
ENV TB_VERSION=4.0.1
ENV DATA_FOLDER=/data
ENV HSQLDB_DATA_DIR=/data/db
ENV HTTP_BIND_PORT=8080
ENV DATABASE_TS_TYPE=sql

# Create required directories
WORKDIR /thingsboard
RUN mkdir -p ${HSQLDB_DATA_DIR} /config /log

# Copy startup script
COPY railway-start.sh /thingsboard/railway-start.sh
RUN chmod +x /thingsboard/railway-start.sh

# Download and extract ThingsBoard minimal jar (just the core without extras)
RUN apk add --no-cache wget unzip \
    && wget -q -O tb.jar https://github.com/thingsboard/thingsboard/releases/download/v${TB_VERSION}/thingsboard-${TB_VERSION}-boot.jar \
    && chmod +x tb.jar

# Configure HSQLDB for minimal usage
ENV SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.HSQLDialect
ENV SPRING_DRIVER_CLASS_NAME=org.hsqldb.jdbc.JDBCDriver
ENV SPRING_DATASOURCE_URL=jdbc:hsqldb:file:${HSQLDB_DATA_DIR}/thingsboardDb;sql.enforce_size=false
ENV SPRING_DATASOURCE_USERNAME=sa
ENV SPRING_DATASOURCE_PASSWORD=

# Expose necessary ports
EXPOSE 8080 1883 5683/udp

# Start service with minimal options
CMD ["/thingsboard/railway-start.sh"] 