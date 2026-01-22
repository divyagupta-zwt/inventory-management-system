CREATE DEFINER=`root`@`localhost` PROCEDURE `place_order`(
	in p_customer_name varchar(100),
	in p_warehouse_id int,
    in p_items json,
    out p_order_id int
)
BEGIN
	declare i int default 0;
	declare items_count int;
    declare v_product_id int;
    declare v_quantity int;
    declare v_price decimal(10,2);
    
    start transaction;
    
    if not exists(
		select 1 from warehouse
		where warehouse_id = p_warehouse_id) then
		signal sqlstate '45000'
		set message_text= 'Invalid warehouse';
    end if;
    
    set items_count= json_length(p_items);
    
    while i< items_count do 
    set v_product_id= json_extract(p_items, concat('$[',i,'].product_id'));
    set v_quantity= json_extract(p_items, concat('$[',i,'].quantity'));
    
    if not exists(
		select 1 from products
        where product_id= v_product_id) then
        set @message_text= concat('Invalid product_id ', v_product_id);
        signal sqlstate '45000'
        set message_text= @message_text;
	end if;
    
    if(select quantity from warehouse_stock
    where warehouse_id= p_warehouse_id
    and product_id= v_product_id) < v_quantity then
    set @message_text= concat('Insufficient stock for product_id ', v_product_id);
    signal sqlstate '45000'
    set message_text= @message_text;
    end if;
    
    set i= i+1;
    end while;
    
    insert into orders(customer_name, order_date, warehouse_id, status)
    values(p_customer_name, now(), p_warehouse_id, 'PLACED');
    
    set p_order_id= last_insert_id();
    
    set i=0;
    while i< items_count do
    set v_product_id= json_extract(p_items, concat('$[',i,'].product_id'));
    set v_quantity= json_extract(p_items, concat('$[',i,'].quantity'));
    
    select price into v_price from products
    where product_id= v_product_id;
    
    insert into order_items(order_id, product_id, quantity, price)
    values (p_order_id, v_product_id, v_quantity, v_price);
    
    update order_items
    set price= v_quantity * v_price
    where product_id= v_product_id;
    
    update warehouse_stock
    set quantity= quantity - v_quantity
    where warehouse_id= p_warehouse_id
    and product_id= v_product_id;
    
    set i= i+1;
    end while;
    
    commit;
END