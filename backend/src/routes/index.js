const express = require('express');
const router = express.Router();
const productRoutes = require('./product.routes');
const storeRoutes = require('./store.routes');

router.use('/products', productRoutes);
router.use('/stores', storeRoutes);

module.exports = router; 