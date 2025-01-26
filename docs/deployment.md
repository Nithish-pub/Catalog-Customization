# Deployment Guide

## Prerequisites
- Node.js v14+
- Docker
- Elasticsearch v8.x
- Flutter SDK

## Backend Deployment

### Using Docker

1. Build the Docker image:
```bash
cd backend
docker build -t store-catalog-backend .
```

2. Run the container:
```bash
docker run -d \
  --name store-catalog-backend \
  -p 3000:3000 \
  -e ELASTICSEARCH_NODE=http://elasticsearch:9200 \
  -e NODE_ENV=production \
  store-catalog-backend
```

### Manual Deployment

1. Install dependencies:
```bash
cd backend
npm install --production
```

2. Set environment variables:
```bash
export ELASTICSEARCH_NODE=http://your-elasticsearch-host:9200
export NODE_ENV=production
export PORT=3000
```

3. Start the server:
```bash
npm start
```

## Frontend Deployment

### Android

1. Build APK:
```bash
cd frontend
flutter build apk --release
```
The APK will be available at `build/app/outputs/flutter-apk/app-release.apk`

### iOS

1. Build iOS app:
```bash
cd frontend
flutter build ios --release
```

2. Open Xcode and archive the app:
```bash
open ios/Runner.xcworkspace
```

### Web (Optional)

1. Build web version:
```bash
cd frontend
flutter build web --release
```

## Environment Variables

### Backend
```env
ELASTICSEARCH_NODE=http://elasticsearch:9200
NODE_ENV=production
PORT=3000
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
CACHE_TTL=300
```

### Frontend
Update `lib/config/environment.dart` with production API URL.

## Monitoring

1. Set up logging:
```bash
# Backend logs
docker logs -f store-catalog-backend

# Elasticsearch logs
docker logs -f elasticsearch
```

2. Health check endpoint:
```bash
curl http://your-api-host/api/health
```

## Backup

1. Elasticsearch data:
```bash
# Create snapshot
curl -X PUT "localhost:9200/_snapshot/my_backup/snapshot_1?wait_for_completion=true"
```

## Security Considerations

1. Enable Elasticsearch security:
```yaml
xpack.security.enabled: true
```

2. Set up HTTPS for API
3. Configure CORS properly
4. Enable rate limiting
5. Implement API authentication 