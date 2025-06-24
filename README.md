# DevOps Assignment: Nginx Reverse Proxy with Docker Compose

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Go](https://img.shields.io/badge/Go-00ADD8?style=for-the-badge&logo=go&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

A production-ready containerized system featuring Nginx reverse proxy routing to Go and Python microservices with comprehensive health monitoring and logging.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐
│   Client        │    │   Load Balancer │
│   Requests      │───▶│   (Future)      │
└─────────────────┘    └─────────────────┘
                                │
                                ▼
                    ┌─────────────────┐
                    │  Nginx Proxy    │
                    │  (Port 8080)    │
                    └─────────────────┘
                            │
            ┌───────────────┼───────────────┐
            ▼               ▼               ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │   /service1  │ │   /service2  │ │   /health    │
    │              │ │              │ │              │
    │  Go Service  │ │ Python Svc   │ │ Health Check │
    │  (Port 8081) │ │ (Port 8082)  │ │              │
    └──────────────┘ └──────────────┘ └──────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git
- curl (for testing)

### One-Command Setup
```bash
# Clone and start
git clone <your-repo-url>
cd devops-assignment
make dev  # or docker-compose up --build
```

### Manual Setup
```bash
# Build and start services
docker-compose up --build -d

# Verify everything is working
curl http://localhost:8080/health
curl http://localhost:8080/service1
curl http://localhost:8080/service2
```

## 📊 Service Endpoints

| Endpoint | Service | Description |
|----------|---------|-------------|
| `http://localhost:8080/` | Root | Welcome message and service list |
| `http://localhost:8080/health` | Nginx | Health check endpoint |
| `http://localhost:8080/service1` | Go App | Routes to Go microservice |
| `http://localhost:8080/service2` | Python App | Routes to Python microservice |

## 🔧 Configuration Details

### Routing Logic
- **Path-based routing**: Requests are routed based on URL prefixes
- **URL rewriting**: Service prefixes are stripped before forwarding
- **Load balancing ready**: Configured for multiple backend instances

### Network Architecture
- **Bridge networking**: All services communicate via Docker bridge network
- **Service discovery**: Services communicate using container names
- **Port isolation**: Backend services only expose ports internally

### Health Monitoring
- **Multi-level health checks**: Nginx, Go service, and Python service
- **Dependency management**: Nginx waits for backend services to be healthy
- **Configurable intervals**: 30s intervals with 3 retry attempts

## 📈 Monitoring & Logging

### Log Format
```
IP - User [Timestamp] "Request" Status Bytes "Referer" "User-Agent" 
response_time upstream_connect_time upstream_header_time upstream_response_time upstream_addr
```

### Monitoring Commands
```bash
# Real-time logs
make logs                    # All services
make logs-nginx             # Nginx only
docker-compose logs -f      # Alternative

# Container status
make status                 # Detailed status with resource usage
docker-compose ps          # Basic status

# Health checks
make health                # Quick health verification
make test                  # Comprehensive testing
```

## 🛠️ Development Workflow

### Using Makefile (Recommended)
```bash
make help           # Show all available commands
make dev            # Full development setup
make test           # Run comprehensive tests
make clean          # Clean up resources
```

### Manual Commands
```bash
# Development
docker-compose up --build -d    # Start services
docker-compose down             # Stop services
docker-compose logs -f          # View logs

# Testing
./test.sh                       # Automated testing
curl http://localhost:8080/     # Manual testing

# Debugging
docker-compose exec nginx /bin/sh    # Access nginx container
make debug-service1                  # Access go service container
```

## 🧪 Testing Strategy

### Automated Testing
The included `test.sh` script performs:
- ✅ Health endpoint verification
- ✅ Service routing validation
- ✅ Container health status checks
- ✅ Network connectivity testing
- ✅ Load testing with multiple requests
- ✅ Log verification

### Manual Testing
```bash
# Basic connectivity
curl http://localhost:8080/

# Service routing
curl http://localhost:8080/service1
curl http://localhost:8080/service2

# Health monitoring
curl http://localhost:8080/health

# Load testing
for i in {1..100}; do curl -s http://localhost:8080/service1 & done; wait
```

## 🔒 Security Features

- **Non-root containers**: Services run as non-privileged users
- **Network isolation**: Services communicate only through defined networks
- **Security headers**: Proper HTTP headers for security
- **Resource limits**: Configurable memory and CPU limits
- **Log sanitization**: Secure logging without sensitive data exposure

## 📦 Production Considerations

### Scalability
```bash
# Scale services horizontally
docker-compose up -d --scale service1=3 --scale service2=2

# Using Makefile
make scale-up    # Scale to 2 instances each
make scale-down  # Scale back to 1 instance each
```

### Performance Optimizations
- **Gzip compression**: Enabled for static content
- **Keep-alive connections**: Persistent connections to backends
- **Connection pooling**: Upstream keepalive configuration
- **Efficient logging**: Structured logs with proper rotation

### Monitoring Integration
Ready for integration with:
- **Prometheus**: Metrics collection
- **Grafana**: Visualization dashboards  
- **ELK Stack**: Centralized logging
- **Jaeger**: Distributed tracing

## 🐛 Troubleshooting

### Common Issues

**Services not starting:**
```bash
# Check container status
docker-compose ps

# View detailed logs
docker-compose logs service1
docker-compose logs service2
```

**Port already in use:**
```bash
# Find process using port 8080
lsof -i :8080
# Kill the process or change port in docker-compose.yml
```

**Network connectivity issues:**
```bash
# Test internal network
make network-test

# Manual network check
docker-compose exec nginx ping service1
docker-compose exec nginx ping service2
```

**Health checks failing:**
```bash
# Check health check configuration
docker inspect --format='{{json .State.Health}}' go-service

# View health check logs
docker-compose logs service1 | grep health
```

### Debug Mode
```bash
# Access container shells for debugging
make debug-nginx     # Nginx container
make debug-service1  # Go service container
make debug-service2  # Python service container

# Check nginx configuration
docker-compose exec nginx nginx -t
```

## 📋 Bonus Features Implemented

### ✅ Enhanced Logging
- Detailed access logs with response times
- Upstream server information
- Request tracing capabilities
- Structured log format for analysis

### ✅ Comprehensive Health Checks
- Application-level health endpoints
- Container health monitoring
- Dependency health verification
- Configurable health check parameters

### ✅ Professional Automation
- Makefile with 20+ commands
- Automated testing script
- CI/CD pipeline helpers
- Development workflow optimization

### ✅ Production Readiness
- Multi-stage Docker builds
- Security best practices
- Resource optimization
- Scalability configuration

### ✅ Monitoring & Observability
- Real-time monitoring dashboard
- Performance metrics collection
- Log aggregation setup
- Health status reporting

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
name: DevOps Assignment CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run tests
        run: make ci-test
```

### Pipeline Commands
```bash
make ci-test        # CI/CD test pipeline
make prod-check     # Production readiness verification
make backup-logs    # Backup logs for analysis
```

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Configuration Guide](https://nginx.org/en/docs/)
- [Container Health Checks](https://docs.docker.com/engine/reference/builder/#healthcheck)
- [Docker Networking](https://docs.docker.com/network/)

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is part of a DevOps internship assignment and is for educational purposes.

---

**Built with ❤️ for DevOps Excellence**

*For questions or support, please refer to the troubleshooting section or create an issue.*