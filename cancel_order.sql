CREATE DEFINER=`root`@`localhost` PROCEDURE `cancel_order`(
	in p_order_id int
)
BEGIN
	declare done int default 0;
	declare v_quantity int;
    declare v_status varchar(20);
    declare v_warehouse_id int;
    declare v_product_id int;
    declare cancel_cur cursor for
		select product_id, quantity from order_items
        where order_id= p_order_id;
	declare continue handler for not found set done= 1;
    
    start transaction;
    
    select status, warehouse_id into v_status, v_warehouse_id from orders
    where order_id= p_order_id;
    
    if v_status <> 'PLACED' then
    signal sqlstate '45000'
    set message_text= 'Order cannot be cancelled';
    end if;
    
    open cancel_cur;
    
    read_loop: loop
		fetch cancel_cur into v_product_id, v_quantity;
        if done= 1 then
			leave read_loop;
        end if;    
    
    update warehouse_stock
    set quantity= quantity + v_quantity
    where warehouse_id= v_warehouse_id
    and product_id= v_product_id;
    
    end loop;
    
    close cancel_cur;    
    
    update orders set status= 'CANCELLED'
    where order_id= p_order_id;
    
    commit;
END