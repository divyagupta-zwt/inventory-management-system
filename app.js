require('dotenv').config();
const express= require('express');
const app= express();
const orderRoutes= require('./routes/order-routes');
const warehouseRoutes= require('./routes/warehouse-routes')

app.use(express.json());
app.use('/api/orders', orderRoutes);
app.use('/api', warehouseRoutes);

const PORT= process.env.PORT || 3000;

app.listen(PORT,()=>{
    console.log(`Server is running at http://localhost:${PORT}`);
});