create database inventory_management;
use inventory_management;
create table warehouse(
	warehouse_id int primary key auto_increment,
    warehouse_name varchar(100),
    location varchar(100)
);
create table products(
	product_id int primary key auto_increment,
    product_name varchar(100),
    sku varchar(50) unique,
    price decimal(10,2)
);
create table warehouse_stock(
	warehouse_id int,
    product_id int,
    quantity int,
    primary key (warehouse_id, product_id),
    foreign key (warehouse_id) references warehouse(warehouse_id),
    foreign key (product_id) references products(product_id)
);
create table orders(
	order_id int primary key auto_increment,
    customer_name varchar(100),
    order_date datetime,
    warehouse_id int,
    status enum('PLACED', 'CANCELLED', 'COMPLETED'),
    foreign key (warehouse_id) references warehouse(warehouse_id)
);
create table order_items(
	order_id int,
    product_id int,
    quantity int,
    price decimal(10,2),
    primary key (order_id, product_id),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);
insert into warehouse(warehouse_name, location) values
('North Logistics Hub', 'Chicago'),
('South Distribution Center', 'Atlanta'),
('West Coast Depot', 'Los Angeles'),
('East Coast Storage', 'New York');
select *  from warehouse;
insert into products(product_name, sku, price) values
('Laptop 14 Inch', 'LAP-14IN', 65000.00),
('Wireless Mouse', 'MOU-WRL', 799.00),
('Mechanical Keyboard', 'KEY-MECH', 3499.00),
('LED Monitor 24 Inch', 'MON-24IN', 12500.00),
('External Hard Drive 1TB', 'HDD-1TB', 2999.00),
('USB-C Charging Adapter', 'USB-C-ADP', 1499.00),
('Ergonomic Office Chair', 'CHR-ERGO', 8500.00),
('Dual Band WiFi Router', 'RTR-DB-WIFI', 2899.00);
select * from products;
insert into warehouse_stock(warehouse_id, product_id, quantity) values
(1, 1, 200),
(1, 2, 180),
(1, 3, 185),
(1, 4, 200),
(1, 5, 200),
(1, 6, 180),
(1, 7, 185),
(1, 8, 200),
(2, 1, 200),
(2, 2, 180),
(2, 3, 185),
(2, 4, 200),
(2, 5, 220),
(2, 6, 170),
(2, 7, 165),
(2, 8, 200),
(3, 1, 150),
(3, 2, 180),
(3, 3, 175),
(3, 4, 100),
(3, 5, 200),
(3, 6, 180),
(3, 7, 185),
(3, 8, 200),
(4, 1, 200),
(4, 2, 180),
(4, 3, 185),
(4, 4, 200),
(4, 5, 200),
(4, 6, 160),
(4, 7, 145),
(4, 8, 150);
select * from warehouse_stock;
select * from orders;
select * from order_items;
truncate warehouse;