# ThingsBoard Deployment

This repository contains Docker configuration to deploy ThingsBoard IoT platform.

## Free Hosting Options for 1 Week Trial

### Option 1: Railway (Recommended)

1. Go to [Railway](https://railway.app/) and sign up
2. Connect your GitHub account
3. Create a new project and select "Deploy from GitHub repo"
4. Select this repository
5. Railway will automatically detect the docker-compose.yml and deploy ThingsBoard

Note: Railway offers $5 free credit which is sufficient for a 1-week trial.

### Option 2: Fly.io

1. Install the [flyctl CLI](https://fly.io/docs/hands-on/install-flyctl/)
2. Sign up for Fly.io: `flyctl auth signup`
3. Deploy ThingsBoard: `flyctl launch`

Note: Fly.io offers a free tier with 3 shared-cpu-1x VMs.

## ThingsBoard Configuration

Default credentials:
- User: tenant@thingsboard.org
- Password: tenant

Important ports:
- Web UI: 8080
- MQTT: 1883
- CoAP: 5683/udp

## Connecting Sensors

1. Create a device in ThingsBoard UI
2. Generate access token for the device
3. Configure your sensors to connect using MQTT:
   - URL: your-deployment-url:1883
   - User: Access token
   - Password: (leave empty)
   - Topic: v1/devices/me/telemetry 