const { expect } = require('chai');
const sinon = require('sinon');
const ProductService = require('../src/services/product.service');
const elasticClient = require('../src/config/elasticsearch');

describe('ProductService', () => {
  let productService;
  
  beforeEach(() => {
    productService = new ProductService();
  });

  afterEach(() => {
    sinon.restore();
  });

  describe('getProductsByStore', () => {
    it('should return products for a given store', async () => {
      const mockResponse = {
        body: {
          hits: {
            total: { value: 1 },
            hits: [{
              _id: '1',
              _source: {
                name: 'Test Product',
                description: 'Test Description',
                category: 'Electronics',
                stores: [{
                  storeId: 'store_1',
                  price: 100,
                  isDeliveryAvailable: true
                }]
              }
            }]
          }
        }
      };

      sinon.stub(elasticClient, 'search').resolves(mockResponse);

      const result = await productService.getProductsByStore('store_1', 1, 20);
      expect(result.products).to.have.lengthOf(1);
      expect(result.products[0].name).to.equal('Test Product');
    });
  });
}); 