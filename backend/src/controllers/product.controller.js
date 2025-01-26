const productService = require('../services/product.service');
const elasticClient = require('../clients/elastic.client');

class ProductController {
  async getProductsByStore(req, res) {
    try {
      const { storeId } = req.params;
      const { page = 1, limit = 20 } = req.query;
      
      const result = await elasticClient.search({
        index: 'products',
        body: {
          query: {
            nested: {
              path: 'stores',
              query: {
                bool: {
                  must: [{ term: { 'stores.storeId': storeId } }]
                }
              }
            }
          },
          from: (page - 1) * limit,
          size: limit
        }
      });

      res.json({
        products: result.hits.hits.map(hit => ({
          id: hit._id,
          ...hit._source
        })),
        total: result.hits.total.value
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async searchProducts(req, res) {
    try {
      const { 
        storeId, 
        query, 
        category, 
        minPrice, 
        maxPrice, 
        deliveryOnly = false,
        page = 1, 
        limit = 20 
      } = req.query;
      
      const searchQuery = {
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
                      { term: { 'stores.inStoreAvailable': false } }
                    ]
                  }
                }
              }
            }
          ]
        }
      };

      if (query) {
        searchQuery.bool.must.push({
          multi_match: {
            query,
            fields: ['name', 'description']
          }
        });
      }

      if (category) {
        searchQuery.bool.must.push({
          term: { category }
        });
      }

      const result = await elasticClient.search({
        index: 'products',
        body: {
          query: searchQuery,
          from: (page - 1) * limit,
          size: limit
        }
      });

      res.json({
        products: result.hits.hits.map(hit => ({
          id: hit._id,
          ...hit._source
        })),
        total: result.hits.total.value
      });
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }

  async getProductDetails(req, res) {
    try {
      const { productId, storeId } = req.params;
      
      const result = await elasticClient.search({
        index: 'products',
        body: {
          query: {
            bool: {
              must: [
                { term: { _id: productId } },
                {
                  nested: {
                    path: 'stores',
                    query: {
                      term: { 'stores.storeId': storeId }
                    }
                  }
                }
              ]
            }
          }
        }
      });

      if (result.hits.total.value === 0) {
        return res.status(404).json({ error: 'Product not found' });
      }

      const product = {
        id: result.hits.hits[0]._id,
        ...result.hits.hits[0]._source
      };

      res.json(product);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new ProductController(); 