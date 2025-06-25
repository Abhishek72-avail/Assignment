#!/bin/bash

# Health Check and Testing Script for Nginx Reverse Proxy Setup

echo "🏥 Starting Health Check and Testing..."
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test endpoint
test_endpoint() {
    local url=$1
    local name=$2
    echo -n "Testing $name ($url)... "
    
    if curl -s -o /dev/null -w "%{http_code}" "$url" | grep -q "200"; then
        echo -e "${GREEN}✅ PASSED${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED${NC}"
        return 1
    fi
}

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 5

# Test main page
test_endpoint "http://localhost:8080" "Main Page"

# Test nginx health
test_endpoint "http://localhost:8080/nginx-health" "Nginx Health"

# Test service 1
test_endpoint "http://localhost:8080/service1/" "Service 1 (Go)"

# Test service 2  
test_endpoint "http://localhost:8080/service2/" "Service 2 (Python)"

echo ""
echo "🔍 Checking Docker Container Status..."
echo "======================================"
docker-compose ps

echo ""
echo "📊 Checking Health Status..."
echo "============================"
docker-compose exec -T nginx curl -s http://localhost/nginx-health
echo ""

echo "📝 Recent Access Logs (last 10 lines)..."
echo "========================================="
if [ -f "nginx/logs/access.log" ]; then
    tail -10 nginx/logs/access.log
else
    echo "Access log file not found. Logs might be in container."
fi

echo ""
echo "🚀 Load Testing (10 concurrent requests)..."
echo "==========================================="
for i in {1..10}; do
    curl -s http://localhost:8080/service1/ > /dev/null &
    curl -s http://localhost:8080/service2/ > /dev/null &
done
wait

echo ""
echo "✅ Health check and testing completed!"
echo "📱 Access your application at: http://localhost:8080"