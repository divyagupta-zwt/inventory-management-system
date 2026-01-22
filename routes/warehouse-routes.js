const express= require('express');
const router= express.Router();
const {getStock}= require('../controllers/warehouse-controller');

router.get('/warehouse/:id/stock', getStock);

module.exports= router;