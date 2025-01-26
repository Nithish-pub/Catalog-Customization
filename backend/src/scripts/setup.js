const client = require('../config/elasticsearch');

async function setupElasticsearch() {
  // Add index settings for optimization
  const indexSettings = {
    settings: {
      index: {
        number_of_shards: 3,
        number_of_replicas: 1,
        'mapping.nested_fields.limit': 100,
        'mapping.total_fields.limit': 1000,
        'index.refresh_interval': '1s'
      },
      analysis: {
        analyzer: {
          product_analyzer: {
            type: 'custom',
            tokenizer: 'standard',
            filter: ['lowercase', 'asciifolding', 'word_delimiter']
          }
        }
      }
    }
  };

  // Create index with mapping
  await client.indices.create({
    index: 'products',
    body: {
      ...indexSettings,
      mappings: {
        properties: {
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
              deliveryEstimate: { type: 'integer' },
              location: {
                type: 'geo_point',
                lat: { type: 'float' },
                lon: { type: 'float' }
              },
              region: { type: 'keyword' },
              population_density: { type: 'keyword' }
            }
          },
          promotions: {
            type: 'nested',
            properties: {
              id: { type: 'keyword' },
              title: { type: 'text' },
              description: { type: 'text' },
              discount_percentage: { type: 'float' },
              valid_from: { type: 'date' },
              valid_to: { type: 'date' },
              applicable_categories: { type: 'keyword' }
            }
          }
        }
      }
    }
  });

  // Generate sample data
  const sampleProducts = [];
  const categories = ['Electronics', 'Furniture', 'Groceries', 'Clothing'];
  
  for (let i = 1; i <= 10000; i++) {
    const product = {
      name: `Product ${i}`,
      description: `Description for product ${i}`,
      category: categories[Math.floor(Math.random() * categories.length)],
      stores: []
    };

    // Add store-specific data
    for (let storeId = 1; storeId <= 50; storeId++) {
      if (Math.random() > 0.3) {
        product.stores.push({
          storeId: `store_${storeId}`,
          price: Math.random() * 1000 + 10,
          isDeliveryAvailable: Math.random() > 0.5,
          inStoreAvailable: Math.random() > 0.5,
          location: {
            lat: Math.random() * (45 - 25) + 25, // US latitude range
            lon: Math.random() * (-70 - -125) + -125 // US longitude range
          },
          region: ['urban', 'suburban', 'rural'][Math.floor(Math.random() * 3)],
          population_density: Math.floor(Math.random() * 10000)
        });
      }
    }

    sampleProducts.push(product);
  }

  // Bulk index the products
  const body = sampleProducts.flatMap(doc => [
    { index: { _index: 'products' } },
    doc
  ]);

  await client.bulk({ body });
  console.log('Setup completed successfully');
}

setupElasticsearch().catch(console.error); 