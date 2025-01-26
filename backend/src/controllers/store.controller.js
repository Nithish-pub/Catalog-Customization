class StoreController {
  async getAllStores(req, res) {
    try {
      // Generate sample stores
      const stores = Array.from({ length: 50 }, (_, i) => ({
        id: `store_${i + 1}`,
        name: `Store ${i + 1}`,
        address: `${i + 1} Main Street, City ${i + 1}`
      }));
      
      res.json(stores);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
}

module.exports = new StoreController(); 