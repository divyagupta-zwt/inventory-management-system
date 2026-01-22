const express= require('express');
const router= express.Router();
const {placeOrder, cancelOrder, getOrders}= require('../controllers/order-controller');

router.post('/orders', placeOrder);
router.put('/orders/:id/cancel', cancelOrder);
router.get('/orders', getOrders);

module.exports= router;