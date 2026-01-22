const db= require('../config/db');

exports.getStock= async (req, res)=>{
    try {
        const [rows]= await db.query(`select p.product_name, ws.quantity from warehouse_stock ws join products p on ws.product_id= p.product_id where warehouse_id = ?;`, [req.params.id]);
        res.json(rows);
    } catch (error) {
        res.status(400).json({error: error.message});
    }
}