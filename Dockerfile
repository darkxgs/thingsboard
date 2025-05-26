FROM thingsboard/tb-postgres:4.0.1

# Memory optimization
ENV JAVA_OPTS="-Xms64m -Xmx256m -XX:+ExitOnOutOfMemoryError -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -Dplatform=railway"
ENV TB_QUEUE_TYPE=in-memory
ENV DATABASE_TS_TYPE=sql
ENV TB_LOAD_DEMO=false

# Use HSQLDB instead of PostgreSQL
ENV SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.HSQLDialect
ENV SPRING_DRIVER_CLASS_NAME=org.hsqldb.jdbc.JDBCDriver
ENV SPRING_DATASOURCE_URL=jdbc:hsqldb:file:/data/db/thingsboardDb;sql.enforce_size=false;hsqldb.log_size=5
ENV SPRING_DATASOURCE_USERNAME=sa
ENV SPRING_DATASOURCE_PASSWORD=

# Expose ports
EXPOSE 8080 1883 5683/udp

# Configure startup
RUN mkdir -p /data/db

# Use reduced functionality for lightweight operation
CMD ["sh", "-c", "java $JAVA_OPTS -Dinstall.load_demo=false -Dservice.type=monolith -Dactors.system.throughput=3 -Dui.help.enabled=false -jar /usr/share/thingsboard/bin/thingsboard.jar"] 