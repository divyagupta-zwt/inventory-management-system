const db= require('../config/db');

exports.placeOrder= async (req, res)=>{
    const {customer_name, warehouse_id, items}= req.body;

    try{
        const conn= await db.getConnection();
        const [result]= await conn.query(`call place_order(?,?,?, @order_id)`, [customer_name, warehouse_id, JSON.stringify(items)]);
        const [[{order_id}]]= await conn.query(`select @order_id as order_id;`);
        conn.release();
        res.status(201).json({
            message: "Order placed successfully",
            order_id: order_id
        });
    } catch(error){
        res.status(400).json({error: error.message});
    }
}

exports.cancelOrder= async (req, res)=>{
    try {
        await db.query(`call cancel_order(?)`, [req.params.id]);
        res.json("Order cancelled successfully");
    } catch (error) {
        res.status(400).json({error: error.message});
    }
}

exports.getOrders= async (req, res)=> {
    try {
        const [rows]= await db.query(`select o.order_id, o.customer_name, w.warehouse_name, p.product_name, oi.quantity, (oi.quantity*oi.price) as 'total_amount' from orders o join warehouse w on o.warehouse_id= w.warehouse_id join order_items oi on o.order_id= oi.order_id join products p on oi.product_id= p.product_id group by o.order_id, p.product_id;`);
        res.json(rows);
    } catch (error) {
        res.status(400).json({error: error.message});
    }
}