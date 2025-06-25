# Nginx Reverse Proxy + Docker Assignment

This project demonstrates a Docker Compose setup with an Nginx reverse proxy routing requests to two backend services (Go and Python applications).

## 🏗️ Architecture

```
Internet → Nginx (Port 8080) → Service 1 (Go - Port 8001)
                             → Service 2 (Python - Port 8002)
```

## 📁 Project Structure

```
.
├── docker-compose.yml          # Main orchestration file
├── nginx/
│   ├── nginx.conf             # Nginx configuration with routing
│   └── Dockerfile             # Nginx container setup
├── service_1/
│   ├── Dockerfile             # Go application container
│   ├── main.go                # Go source code
│   ├── go.mod                 # Go dependencies
│   └── go.sum
├── service_2/
│   ├── Dockerfile             # Python application container
│   ├── app.py                 # Python source code
│   └── requirements.txt       # Python dependencies
└── README.md                  # This file
```

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Docker Compose installed
- Git (for version control)

### Setup Instructions

1. **Clone or download the project**
   ```bash
   git clone <your-repo-url>
   cd nginx-reverse-proxy-assignment
   ```

2. **Build and start all services**
   ```bash
   docker-compose up --build
   ```

3. **Access the application**
   - Main page: http://localhost:8080
   - Go service: http://localhost:8080/service1/
   - Python service: http://localhost:8080/service2/
   - Nginx health: http://localhost:8080/nginx-health

## 🔄 How Routing Works

### Nginx Configuration
- **Port 8080**: Single entry point for all requests
- **Path-based routing**: Routes requests based on URL prefixes
- **Load balancing**: Ready for multiple instances of each service

### Route Mapping
| URL Path | Destination | Internal Port |
|----------|-------------|---------------|
| `/service1/` | Go Application | 8001 |
| `/service2/` | Python Application | 8002 |
| `/nginx-health` | Nginx health check | - |
| `/` | Welcome page with links | - |

### URL Rewriting
- `/service1/api/users` → `service1:8001/api/users`
- `/service2/data` → `service2:8002/data`

The nginx configuration strips the service prefix before forwarding requests to maintain clean APIs.

## 🔧 Technical Implementation

### Docker Networking
- **Bridge network**: All containers communicate via `app-network`
- **Service discovery**: Containers reference each other by service name
- **Port isolation**: Backend services only expose ports internally

### Health Checks
- **Nginx**: `/nginx-health` endpoint
- **Service 1 (Go)**: `/health` endpoint with 30s intervals
- **Service 2 (Python)**: `/health` endpoint with 30s intervals

### Logging
- **Access logs**: Detailed format with timestamps, paths, and upstream info
- **Error logs**: Comprehensive error tracking
- **Log location**: `./nginx/logs/` (mounted volume)

## 🔍 Monitoring and Debugging

### View logs in real-time
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f nginx
docker-compose logs -f service1
docker-compose logs -f service2
```

### Check service health
```bash
# Container status
docker-compose ps

# Health check status
docker inspect <container_name> | grep Health -A 10
```

### Access nginx logs
```bash
# Access logs
tail -f nginx/logs/access.log

# Error logs
tail -f nginx/logs/error.log
```

## 🧪 Testing the Setup

### Basic connectivity test
```bash
# Test main page
curl http://localhost:8080

# Test service 1
curl http://localhost:8080/service1/

# Test service 2
curl http://localhost:8080/service2/

# Test nginx health
curl http://localhost:8080/nginx-health
```

### Load testing (optional)
```bash
# Simple load test with curl
for i in {1..10}; do curl http://localhost:8080/service1/ & done
```

## 🔧 Troubleshooting

### Common Issues

1. **Port 8080 already in use**
   ```bash
   # Change port in docker-compose.yml
   ports:
     - "8081:80"  # Use 8081 instead
   ```

2. **Services not starting**
   ```bash
   # Check logs
   docker-compose logs
   
   # Rebuild containers
   docker-compose down
   docker-compose up --build
   ```

3. **Cannot reach services**
   ```bash
   # Check network connectivity
   docker-compose exec nginx ping service1
   docker-compose exec nginx ping service2
   ```

### Debugging Commands
```bash
# Enter nginx container
docker-compose exec nginx sh

# Check nginx configuration
docker-compose exec nginx nginx -t

# Reload nginx configuration
docker-compose exec nginx nginx -s reload
```

## 🎯 Bonus Features Implemented

### ✅ Health Checks
- All services include health check endpoints
- Docker health check integration
- Automatic restart on failure

### ✅ Comprehensive Logging
- Detailed nginx access logs with timestamps and paths
- Structured error logging
- Log file persistence via volumes

### ✅ Security Hardening
- Non-root users in all containers
- Minimal base images (Alpine Linux)
- Proper file permissions

### ✅ Clean Architecture
- Modular Docker setup
- Proper service isolation
- Bridge networking (no host networking)

## 🛑 Stopping the Application

```bash
# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v

# Stop and remove images
docker-compose down --rmi all
```

## 📋 Development Notes

### Environment Variables
- Services can be configured via environment variables in docker-compose.yml
- Port numbers are configurable
- Logging levels can be adjusted

### Scaling Services
```bash
# Scale service 1 to 3 instances
docker-compose up --scale service1=3

# Scale service 2 to 2 instances
docker-compose up --scale service2=2
```

### Network Configuration
- All services run on isolated bridge network
- No host networking used (as per requirements)
- Services communicate via internal DNS resolution

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 Assignment Completion Checklist

- ✅ Docker Compose orchestration
- ✅ Nginx reverse proxy in container
- ✅ Path-based routing (`/service1`, `/service2`)
- ✅ Single port access (8080)
- ✅ Request logging with timestamps
- ✅ Bridge networking (no host networking)
- ✅ Health checks for all services
- ✅ Clean modular Docker setup
- ✅ Comprehensive documentation

---

**Project completed for DevOps Intern Assignment**  
**Deployment**: Single command - `docker-compose up --build`  
**Access**: http://localhost:8080