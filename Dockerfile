# Use ThingsBoard Postgres image as base
FROM thingsboard/tb-postgres:latest

# Set environment variables
ENV TB_QUEUE_TYPE=in-memory
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/thingsboard
ENV SPRING_DATASOURCE_USERNAME=postgres
ENV SPRING_DATASOURCE_PASSWORD=postgres

# Memory optimization
ENV JAVA_OPTS="-Xms256m -Xmx512m -Dplatform=railway"
ENV TB_LOAD_DEMO=false

# Copy initialization script
WORKDIR /tmp
COPY init-db.sh /tmp/
RUN chmod +x /tmp/init-db.sh

# Expose necessary ports
EXPOSE 8080 1883 5683/udp

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=120s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Set entry point
CMD ["/bin/bash", "/tmp/init-db.sh"] 