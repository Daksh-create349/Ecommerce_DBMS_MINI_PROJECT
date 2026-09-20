-- ==========================================
-- E-Commerce Management System
-- DBMS MINI PROJECT
-- ==========================================




-- ==========================================
-- TABLE CREATION
-- ==========================================


-- Categories Table

CREATE TABLE categories (

    category_id SERIAL PRIMARY KEY,

    category_name VARCHAR(100)
    NOT NULL UNIQUE,

    description TEXT

);



-- Customers Table

CREATE TABLE customers (

    customer_id SERIAL PRIMARY KEY,

    customer_name VARCHAR(100)
    NOT NULL,

    email VARCHAR(150)
    NOT NULL UNIQUE,

    phone VARCHAR(15),

    address TEXT,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);



-- Products Table

CREATE TABLE products (

    product_id SERIAL PRIMARY KEY,

    category_id INT NOT NULL,

    product_name VARCHAR(150)
    NOT NULL,

    sku VARCHAR(50)
    NOT NULL UNIQUE,

    price NUMERIC(10,2)
    NOT NULL CHECK(price >= 0),

    stock INT
    NOT NULL CHECK(stock >= 0),

    specifications JSONB,

    tags TEXT[],


    CONSTRAINT fk_product_category

    FOREIGN KEY(category_id)

    REFERENCES categories(category_id)

);



-- Orders Table

CREATE TABLE orders (

    order_id SERIAL PRIMARY KEY,

    customer_id INT NOT NULL,

    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    delivery_date TIMESTAMP,


    CONSTRAINT fk_order_customer

    FOREIGN KEY(customer_id)

    REFERENCES customers(customer_id),


    CONSTRAINT chk_delivery_date

    CHECK(
        delivery_date IS NULL
        OR delivery_date >= order_date
    )

);



-- Order Items Table

CREATE TABLE order_items (

    order_id INT NOT NULL,

    product_id INT NOT NULL,

    quantity INT NOT NULL
    CHECK(quantity > 0),

    unit_price NUMERIC(10,2) NOT NULL
    CHECK(unit_price >= 0),


    PRIMARY KEY(order_id, product_id),


    CONSTRAINT fk_orderitem_order
    FOREIGN KEY(order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE,


    CONSTRAINT fk_orderitem_product
    FOREIGN KEY(product_id)
    REFERENCES products(product_id)

);



-- ==========================================
-- INSERT DATA
-- ==========================================


-- Categories

INSERT INTO categories
(category_name,description)
VALUES

('Laptops','Portable computers'),

('Smartphones','Mobile devices'),

('Accessories','Electronic accessories'),

('Cameras','Photography devices'),

('Gaming','Gaming products');




-- Customers

INSERT INTO customers
(customer_name,email,phone,address)
VALUES

('Daksh Srivastava','daksh@gmail.com','9876500001','Mumbai'),

('Prathamesh More','prathamesh@gmail.com','9876500002','Delhi'),

('Rohan Mehta','rohan@gmail.com','9876500003','Pune'),

('Sumit Shingole','sumit@gmail.com','9876500004','Bangalore'),

('Arjun Verma','arjun@gmail.com','9876500005','Hyderabad');




-- Products

INSERT INTO products
(category_id,product_name,sku,price,stock,specifications,tags)

VALUES


(1,
'Dell Inspiron Laptop',
'DELL-LAP-001',
65000,
20,

'{
"RAM":"16GB",
"storage":"512GB SSD",
"color":"Black",
"warranty":"2 Years"
}',

ARRAY['laptop','student','office']),



(1,
'HP Pavilion Laptop',
'HP-LAP-002',
72000,
15,

'{
"RAM":"16GB",
"storage":"1TB SSD",
"color":"Silver",
"warranty":"1 Year"
}',

ARRAY['laptop','premium']),



(2,
'OnePlus 13',
'ONE-003',
55000,
30,

'{
"RAM":"12GB",
"storage":"256GB",
"color":"Green",
"warranty":"2 Years"
}',

ARRAY['mobile','5g','android']),



(3,
'Logitech Wireless Mouse',
'LOG-004',
2500,
50,

'{
"color":"Black",
"warranty":"1 Year"
}',

ARRAY['mouse','accessory','wireless']),



(5,
'ASUS Gaming Keyboard',
'ASUS-005',
7000,
25,

'{
"color":"RGB",
"warranty":"2 Years"
}',

ARRAY['gaming','keyboard']);





-- Orders

INSERT INTO orders
(customer_id,order_date,delivery_date)

VALUES

(1,'2026-09-01 10:30:00','2026-09-04 15:00:00'),

(2,'2026-09-02 12:00:00','2026-09-05 14:00:00'),

(3,'2026-09-03 09:45:00','2026-09-06 16:00:00'),

(4,'2026-09-04 11:20:00','2026-09-08 13:00:00'),

(5,'2026-09-05 18:00:00','2026-09-07 12:00:00');





-- Order Items

INSERT INTO order_items

(order_id,product_id,quantity,unit_price)

VALUES

(1,1,1,65000),

(1,4,2,2500),

(2,2,1,72000),

(3,3,1,55000),

(4,5,1,7000),

(5,1,1,65000);





-- ==========================================
-- JSONB OPERATIONS
-- ==========================================


-- Search RAM

SELECT product_name,specifications

FROM products

WHERE specifications @> '{"RAM":"16GB"}';



-- Search Color

SELECT product_name,specifications

FROM products

WHERE specifications @> '{"color":"Black"}';



-- Search Storage

SELECT product_name,specifications

FROM products

WHERE specifications @> '{"storage":"512GB SSD"}';



-- Search Warranty

SELECT product_name,specifications

FROM products

WHERE specifications @> '{"warranty":"2 Years"}';



-- Extract JSON Value

SELECT

product_name,

specifications ->> 'RAM' AS RAM

FROM products;





-- ==========================================
-- ARRAY OPERATIONS
-- ==========================================


-- Search Tag

SELECT product_name,tags

FROM products

WHERE 'laptop'=ANY(tags);



-- Multiple Tags

SELECT product_name,tags

FROM products

WHERE tags @> ARRAY['laptop','student'];



-- Count Tags

SELECT

product_name,

array_length(tags,1) AS total_tags

FROM products;





-- ==========================================
-- DATE OPERATIONS
-- ==========================================


-- Extract Year Month

SELECT

order_id,

EXTRACT(YEAR FROM order_date) AS year,

EXTRACT(MONTH FROM order_date) AS month

FROM orders;




-- Order Duration

SELECT

order_id,

delivery_date-order_date AS duration

FROM orders;




-- Order Age

SELECT

order_id,

AGE(CURRENT_DATE,order_date) AS order_age

FROM orders;





-- ==========================================
-- JOIN QUERY
-- ==========================================


SELECT

c.customer_name,

o.order_id,

p.product_name,

cat.category_name,

oi.quantity,

oi.unit_price


FROM customers c


JOIN orders o

ON c.customer_id=o.customer_id


JOIN order_items oi

ON o.order_id=oi.order_id


JOIN products p

ON oi.product_id=p.product_id


JOIN categories cat

ON p.category_id=cat.category_id;





-- ==========================================
-- GROUP BY QUERY
-- ==========================================


SELECT

cat.category_name,

COUNT(p.product_id) AS total_products


FROM categories cat


JOIN products p

ON cat.category_id=p.category_id


GROUP BY cat.category_name;





-- ==========================================
-- TRANSACTION
-- ==========================================


-- COMMIT

BEGIN;


INSERT INTO orders(customer_id,order_date)

VALUES(1,CURRENT_TIMESTAMP);


UPDATE products

SET stock=stock-1

WHERE product_id=1;


COMMIT;




-- ROLLBACK

BEGIN;


UPDATE products

SET stock=stock-5

WHERE product_id=1;


ROLLBACK;




-- SAVEPOINT

BEGIN;


UPDATE products

SET stock=stock-2

WHERE product_id=1;


SAVEPOINT stock_update;


UPDATE products

SET stock=stock-5

WHERE product_id=1;


ROLLBACK TO SAVEPOINT stock_update;


COMMIT;
