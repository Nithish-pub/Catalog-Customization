# Store Catalog Application

A store-level product catalog application that manages delivery-only products based on store location and demand.

## Overview

This application allows stores to offer an extended product catalog for delivery-only items, with availability tailored to each store's location and demand patterns. For example, bulk items like 26kg rice bags are offered for delivery in densely populated urban areas while being delivery-only in rural locations.

## Features

- Store-specific product catalogs
- Extended catalog for delivery-only items
- Location-based product availability
- Population density-based recommendations
- Product search and filtering
- Store-specific promotions
- Product comparison

## Prerequisites

- Node.js (v14+)
- Flutter (latest version)
- Elasticsearch (v8.x)
- Docker (optional)

## Quick Start

### 1. Start Elasticsearch
```bash
# Using Docker
docker run -d \
  --name elasticsearch \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=false" \
  elasticsearch:8.11.0

# Verify Elasticsearch is running
curl http://localhost:9200
```

### 2. Backend Setup
```bash
# Navigate to backend directory
cd backend

# Install dependencies
npm install

# Create .env file
cp .env.example .env

# Update .env with your configuration:
ELASTICSEARCH_NODE=http://localhost:9200
PORT=3000
NODE_ENV=development

# Initialize Elasticsearch with sample data (10000 SKUs across 50 stores)
npm run setup

# Start the development server
npm run dev

# Verify API is running
curl http://localhost:3000/api/health
```

### 3. Frontend Setup
```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## API Documentation

Once the backend is running, visit:
- Swagger UI: http://localhost:3000/api-docs

### Key Endpoints

- `GET /api/stores` - Get all stores
- `GET /api/products/store/:storeId` - Get products by store
- `GET /api/products/search` - Search products with filters
- `GET /api/products/:productId/store/:storeId` - Get product details

## Project Structure

### Backend
```
backend/
├── src/
│   ├── config/          # Configuration files
│   ├── controllers/     # Request handlers
│   ├── middleware/      # Express middleware
│   ├── routes/         # API routes
│   ├── scripts/        # Setup scripts
│   └── services/       # Business logic
└── server.js           # Entry point
```

### Frontend
```
frontend/
├── lib/
│   ├── models/         # Data models
│   ├── screens/        # UI screens
│   ├── services/       # Business logic
│   ├── utils/          # Helper functions
│   ├── widgets/        # Reusable widgets
│   └── main.dart       # Entry point
├── test/              # Unit tests
└── integration_test/  # E2E tests
```

## Data Model

### Product Schema
```javascript
{
  name: { type: 'text' },
  description: { type: 'text' },
  category: { type: 'keyword' },
  isExtendedCatalog: { type: 'boolean' },
  stores: {
    type: 'nested',
    properties: {
      storeId: { type: 'keyword' },
      price: { type: 'float' },
      isDeliveryAvailable: { type: 'boolean' },
      inStoreAvailable: { type: 'boolean' },
      location: {
        type: 'geo_point',
        lat: { type: 'float' },
        lon: { type: 'float' }
      },
      region: { type: 'keyword' },
      population_density: { type: 'keyword' }
    }
  }
}
```

## Performance Optimizations

- Elasticsearch index settings optimized for search
- Query caching
- Rate limiting
- Connection pooling
- Bulk operations
- Frontend image caching
- Pagination for large datasets

## Troubleshooting

### Common Issues

1. Elasticsearch Connection Issues
```bash
# Check if Elasticsearch is running
curl http://localhost:9200

# Check logs if using Docker
docker logs elasticsearch
```

2. Backend API Issues
```bash
# Check logs
npm run dev

# Verify .env configuration
cat .env
```

3. Frontend Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Development

### Running Tests
```bash
# Backend tests
cd backend
npm test

# Frontend tests
cd frontend
flutter test
```

### Code Generation
```bash
# Generate API models
cd frontend
flutter pub run build_runner build
```

