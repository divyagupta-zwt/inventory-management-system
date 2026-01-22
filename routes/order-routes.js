const express= require('express');
const router= express.Router();
const {placeOrder, cancelOrder, getOrders}= require('../controllers/order-controller');

router.post('/', placeOrder);
router.put('/:id/cancel', cancelOrder);
router.get('/', getOrders);

module.exports= router;