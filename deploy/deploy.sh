#!/bin/bash
# PCM Deployment Script for VPS
# Usage: chmod +x deploy.sh && ./deploy.sh

set -e

echo "🚀 Starting PCM Deployment..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Create directories
echo -e "${YELLOW}📁 Creating directories...${NC}"
mkdir -p /opt/pcm-app/deploy/www
mkdir -p /opt/pcm-app/deploy/downloads

# Step 2: Stop existing containers
echo -e "${YELLOW}🛑 Stopping existing containers...${NC}"
docker-compose down 2>/dev/null || true

# Step 3: Build and start containers
echo -e "${YELLOW}🐳 Building and starting Docker containers...${NC}"
docker-compose build --no-cache
docker-compose up -d

# Step 4: Wait for services
echo -e "${YELLOW}⏳ Waiting for services to start...${NC}"
echo "Waiting 45 seconds for SQL Server to be ready..."
sleep 45

# Step 5: Check services
echo -e "${YELLOW}🔍 Checking services...${NC}"
docker-compose ps

# Step 6: Test API
echo -e "${YELLOW}🧪 Testing API...${NC}"
sleep 5
curl -s http://localhost:5000/api/courts | head -c 200 || echo "API not ready yet"

# Step 7: Test Web
echo ""
echo -e "${YELLOW}🌐 Testing Web...${NC}"
curl -s -o /dev/null -w "%{http_code}" http://localhost/ || echo "Web not ready"

echo ""
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Deployment completed!${NC}"
echo -e "${GREEN}════════════════════════════════════════════${NC}"
echo ""
echo -e "🌐 Web App:  ${GREEN}http://caothuvot.duckdns.org${NC}"
echo -e "📡 API:      ${GREEN}http://caothuvot.duckdns.org/api${NC}"
echo -e "📚 Swagger:  ${GREEN}http://caothuvot.duckdns.org/swagger${NC}"
echo -e "📱 APK:      ${GREEN}http://caothuvot.duckdns.org/download/pcm.apk${NC}"
echo ""
echo -e "📋 Commands:"
echo -e "  docker-compose logs -f    # View logs"
echo -e "  docker-compose restart    # Restart services"
echo -e "  docker-compose down       # Stop all"
echo ""
