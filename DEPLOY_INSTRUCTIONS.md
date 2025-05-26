# ThingsBoard Deployment Instructions for Railway

Follow these steps to deploy ThingsBoard on Railway's free tier:

## 1. Access Railway Web Interface

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Login to your account

## 2. Create a New Project

1. Click "New Project"
2. Select "Deploy from GitHub repo"
3. Find and select your repository "darkxgs/thingsboard"
4. Click "Deploy"

## 3. Configure the Deployment

1. Once the project is created, go to the "Settings" tab
2. Look for "Dockerfile Path" or "Build Settings"
3. Change it to: `Dockerfile.direct`
4. Save the changes

## 4. Set Environment Variables

1. Go to the "Variables" tab
2. Add the following variables:
   - `JAVA_OPTS`: `-Xms64m -Xmx256m -XX:+ExitOnOutOfMemoryError -XX:+UseG1GC -XX:MaxGCPauseMillis=20`
   - `TB_QUEUE_TYPE`: `in-memory`
   - `DATABASE_TS_TYPE`: `sql`
   - `TB_LOAD_DEMO`: `false`
   - `SPRING_JPA_DATABASE_PLATFORM`: `org.hibernate.dialect.HSQLDialect`
   - `SPRING_DRIVER_CLASS_NAME`: `org.hsqldb.jdbc.JDBCDriver`
   - `SPRING_DATASOURCE_URL`: `jdbc:hsqldb:file:/data/db/thingsboardDb;sql.enforce_size=false;hsqldb.log_size=5`
   - `SPRING_DATASOURCE_USERNAME`: `sa`
   - `SPRING_DATASOURCE_PASSWORD`: (leave empty)

## 5. Redeploy the Service

1. Go to the "Deployments" tab
2. Click "Deploy" to start a new deployment with the updated configuration

## 6. Access ThingsBoard

1. Once deployed, go to the "Settings" tab to find your service's domain
2. Access ThingsBoard at that domain (e.g., https://your-service.railway.app)
3. Log in with the default credentials:
   - Username: `admin@thingsboard.org`
   - Password: `admin`

## 7. Connect Your Sensors

Your sensors can connect to:
- MQTT: port 1883
- HTTP/REST: port 8080
- CoAP: port 5683

For example, to connect an MQTT device:
- URL: `your-service.railway.app`
- Port: `1883`
- Username: (your device access token)
- Topic: `v1/devices/me/telemetry` 