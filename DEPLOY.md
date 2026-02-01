# PCM Deployment Guide

## Prerequisites
- VPS with Docker & Docker Compose installed
- SSH access to VPS
- Domain (caothuvot.duckdns.org) pointing to VPS IP

## Step 1: Stop local backend
```bash
# Press Ctrl+C in the terminal running "dotnet run"
```

## Step 2: Upload files to VPS
```bash
# From Windows (PowerShell)
scp -r C:\Users\Admin\Desktop\pcm-app\backend root@[VPS-IP]:/opt/pcm-app/
scp -r C:\Users\Admin\Desktop\pcm-app\deploy root@[VPS-IP]:/opt/pcm-app/
scp C:\Users\Admin\Desktop\pcm-app\docker-compose.yml root@[VPS-IP]:/opt/pcm-app/
```

Or use FileZilla/WinSCP to upload:
- `/opt/pcm-app/backend/` - Backend source code
- `/opt/pcm-app/deploy/` - Nginx config, web files, scripts
- `/opt/pcm-app/docker-compose.yml` - Docker compose file

## Step 3: SSH to VPS and deploy
```bash
ssh root@[VPS-IP]
cd /opt/pcm-app
chmod +x deploy/deploy.sh
./deploy/deploy.sh
```

## Step 4: Verify deployment
```bash
# Check containers
docker-compose ps

# Check logs
docker-compose logs -f

# Test API
curl http://localhost:5000/api/courts

# Test Web
curl http://localhost/
```

## URLs after deployment
- Web App: http://caothuvot.duckdns.org
- API: http://caothuvot.duckdns.org/api
- Swagger: http://caothuvot.duckdns.org/swagger
- APK: http://caothuvot.duckdns.org/download/pcm.apk

## Troubleshooting

### SQL Server not starting
```bash
docker-compose logs sqlserver
# May need more memory, check: free -m
```

### API can't connect to database
```bash
# Wait longer for SQL Server
docker-compose restart pcm-api
```

### Nginx 502 Bad Gateway
```bash
# API not ready
docker-compose restart nginx
```

## Update deployment
```bash
cd /opt/pcm-app
git pull  # or re-upload files
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```
