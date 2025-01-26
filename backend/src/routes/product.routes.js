const express = require('express');
const router = express.Router();
const productController = require('../controllers/product.controller');

/**
 * @swagger
 * components:
 *   schemas:
 *     Product:
 *       type: object
 *       properties:
 *         id:
 *           type: string
 *         name:
 *           type: string
 *         description:
 *           type: string
 *         category:
 *           type: string
 *         isExtendedCatalog:
 *           type: boolean
 *         stores:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/StoreProduct'
 */

/**
 * @swagger
 * /api/products/store/{storeId}:
 *   get:
 *     summary: Get products by store
 *     parameters:
 *       - in: path
 *         name: storeId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           minimum: 1
 *           default: 1
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           minimum: 1
 *           maximum: 100
 *           default: 20
 *     responses:
 *       200:
 *         description: List of products
 */
router.get('/store/:storeId', productController.getProductsByStore);

/**
 * @swagger
 * /api/products/search:
 *   get:
 *     summary: Search products with filters
 *     parameters:
 *       - in: query
 *         name: storeId
 *         required: true
 *         schema:
 *           type: string
 *       - in: query
 *         name: query
 *         schema:
 *           type: string
 *       - in: query
 *         name: category
 *         schema:
 *           type: string
 *       - in: query
 *         name: minPrice
 *         schema:
 *           type: number
 *       - in: query
 *         name: maxPrice
 *         schema:
 *           type: number
 *     responses:
 *       200:
 *         description: Search results
 */
router.get('/search', productController.searchProducts);

router.get('/:productId/store/:storeId', productController.getProductDetails);

module.exports = router; 