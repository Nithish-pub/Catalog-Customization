const elasticClient = require('../config/elasticsearch');

class ProductService {
  async getProductsByStore(storeId, page, limit) {
    const from = (page - 1) * limit;
    
    const { body } = await elasticClient.search({
      index: 'products',
      body: {
        query: {
          bool: {
            must: [
              { term: { "stores.storeId": storeId } },
              { term: { "stores.isDeliveryAvailable": true } }
            ]
          }
        },
        from,
        size: limit
      }
    });

    return this.formatSearchResults(body);
  }

  async searchProducts({ storeId, query, category, minPrice, maxPrice, page, limit }) {
    const from = (page - 1) * limit;
    
    const mustClauses = [
      { term: { "stores.storeId": storeId } },
      { term: { "stores.isDeliveryAvailable": true } }
    ];

    if (query) {
      mustClauses.push({
        multi_match: {
          query,
          fields: ["name", "description"]
        }
      });
    }

    if (category) {
      mustClauses.push({ term: { category } });
    }

    if (minPrice || maxPrice) {
      const rangeQuery = { range: { "stores.price": {} } };
      if (minPrice) rangeQuery.range["stores.price"].gte = minPrice;
      if (maxPrice) rangeQuery.range["stores.price"].lte = maxPrice;
      mustClauses.push(rangeQuery);
    }

    const { body } = await elasticClient.search({
      index: 'products',
      body: {
        query: { bool: { must: mustClauses } },
        from,
        size: limit
      }
    });

    return this.formatSearchResults(body);
  }

  async getProductDetails(productId, storeId) {
    const { body } = await elasticClient.search({
      index: 'products',
      body: {
        query: {
          bool: {
            must: [
              { term: { _id: productId } },
              { term: { "stores.storeId": storeId } }
            ]
          }
        }
      }
    });

    if (body.hits.total.value === 0) {
      throw new Error('Product not found');
    }

    return this.formatProduct(body.hits.hits[0]);
  }

  formatSearchResults(body) {
    const total = body.hits.total.value;
    const hits = body.hits.hits.map(hit => this.formatProduct(hit));

    return {
      total,
      products: hits
    };
  }

  formatProduct(hit) {
    const source = hit._source;
    return {
      id: hit._id,
      name: source.name,
      description: source.description,
      category: source.category,
      stores: source.stores
    };
  }

  async getStoreDeliveryRecommendations(storeId) {
    const store = await getStoreDetails(storeId);
    const isUrbanArea = store.population_density > 5000;
    
    const query = {
      bool: {
        must: [
          {
            nested: {
              path: 'stores',
              query: {
                bool: {
                  must: [
                    { term: { 'stores.storeId': storeId } },
                    { term: { 'stores.isDeliveryAvailable': true } },
                    isUrbanArea 
                      ? { range: { 'stores.price': { gte: 100 } } }  // Higher price threshold for urban
                      : { range: { 'stores.price': { lte: 100 } } }  // Lower price for rural
                  ]
                }
              }
            }
          }
        ]
      }
    };
    // Implementation
  }
}

module.exports = new ProductService(); 