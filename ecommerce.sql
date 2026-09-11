-- ============================================================
-- E-COMMERCE PRODUCT & ORDER MANAGEMENT SYSTEM
-- PostgreSQL Database
-- ============================================================


-- ============================================================
-- 1. CREATE CATEGORIES TABLE
-- ============================================================

CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);


-- ============================================================
-- 2. CREATE PRODUCTS TABLE
-- ============================================================

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id),
    price NUMERIC(10,2) NOT NULL,
    specifications JSONB,
    tags TEXT[]
);


-- ============================================================
-- 3. CREATE CUSTOMERS TABLE
-- ============================================================

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15)
);


-- ============================================================
-- 4. CREATE ORDERS TABLE
-- ============================================================

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    delivery_date DATE,
    order_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 5. CREATE ORDER_ITEMS TABLE
-- Composite Primary Key: order_id + product_id
-- ============================================================

CREATE TABLE order_items (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);


-- ============================================================
-- 6. INSERT CATEGORIES DATA
-- ============================================================

INSERT INTO categories (category_name)
VALUES
('Laptops'),
('Smartphones'),
('Tablets'),
('Smartwatches'),
('Headphones'),
('Cameras'),
('Televisions'),
('Monitors'),
('Keyboards'),
('Gaming Accessories');


-- ============================================================
-- 7. INSERT PRODUCTS DATA
-- JSONB is used for product specifications
-- Array is used for multiple product tags
-- ============================================================

INSERT INTO products (product_name, category_id, price, specifications, tags)
VALUES
('Dell Inspiron 15', 1, 65000,
 '{"ram":"16GB","storage":"512GB SSD","color":"Black","warranty":"1 Year"}',
 ARRAY['laptop','business','student']),

('HP Pavilion 14', 1, 72000,
 '{"ram":"16GB","storage":"1TB SSD","color":"Silver","warranty":"2 Years"}',
 ARRAY['laptop','premium','student']),

('Samsung Galaxy S25', 2, 79999,
 '{"ram":"12GB","storage":"256GB","color":"Blue","warranty":"1 Year"}',
 ARRAY['smartphone','android','flagship']),

('iPhone 16', 2, 79900,
 '{"ram":"8GB","storage":"256GB","color":"Black","warranty":"1 Year"}',
 ARRAY['smartphone','ios','premium']),

('iPad Air', 3, 59900,
 '{"ram":"8GB","storage":"128GB","color":"Purple","warranty":"1 Year"}',
 ARRAY['tablet','apple','student']),

('Apple Watch Series 10', 4, 46900,
 '{"ram":"4GB","storage":"64GB","color":"Silver","warranty":"1 Year"}',
 ARRAY['smartwatch','fitness','apple']),

('Sony WH-1000XM5', 5, 29990,
 '{"ram":"2GB","storage":"16GB","color":"Black","warranty":"1 Year"}',
 ARRAY['headphones','wireless','audio']),

('Canon EOS R50', 6, 58999,
 '{"ram":"8GB","storage":"128GB","color":"Black","warranty":"2 Years"}',
 ARRAY['camera','photography','mirrorless']),

('LG UltraGear Monitor', 8, 32999,
 '{"ram":"4GB","storage":"32GB","color":"Black","warranty":"3 Years"}',
 ARRAY['monitor','gaming','display']),

('Logitech G Pro Keyboard', 9, 14999,
 '{"ram":"2GB","storage":"8GB","color":"White","warranty":"2 Years"}',
 ARRAY['keyboard','gaming','mechanical']);


-- ============================================================
-- 8. INSERT CUSTOMERS DATA
-- ============================================================

INSERT INTO customers (customer_name, email, phone)
VALUES
('Daksh Srivastava', 'daksh@gmail.com', '9876543210'),
('Prathamesh More', 'prathamesh@gmail.com', '9876543211'),
('Yuvraj Mishra', 'yuvraj@gmail.com', '9876543212'),
('Sumit Shingole', 'sumit@gmail.com', '9876543213'),
('Devendra Fadnavis', 'devendra@gmail.com', '9876543214'),
('Eknath Shinde', 'eknath@gmail.com', '9876543215'),
('Uday Samant', 'uday@gmail.com', '9876543216'),
('Pankaja Munde', 'pankaja@gmail.com', '9876543217'),
('Chandrakant Patil', 'chandrakant@gmail.com', '9876543218'),
('Ashish Shelar', 'ashish@gmail.com', '9876543219');


-- ============================================================
-- 9. INSERT ORDERS DATA
-- ============================================================

INSERT INTO orders (customer_id, order_date, delivery_date, order_timestamp)
VALUES
(1, '2026-09-01', '2026-09-04', '2026-09-01 10:30:00'),
(2, '2026-09-02', '2026-09-06', '2026-09-02 14:15:00'),
(3, '2026-09-03', '2026-09-07', '2026-09-03 09:45:00'),
(4, '2026-09-04', '2026-09-08', '2026-09-04 16:20:00'),
(5, '2026-09-05', '2026-09-09', '2026-09-05 11:10:00'),
(6, '2026-09-06', '2026-09-10', '2026-09-06 13:40:00'),
(7, '2026-09-07', '2026-09-11', '2026-09-07 15:25:00'),
(8, '2026-09-08', '2026-09-12', '2026-09-08 10:05:00'),
(9, '2026-09-09', '2026-09-13', '2026-09-09 12:50:00'),
(10, '2026-09-10', '2026-09-14', '2026-09-10 17:30:00');


-- ============================================================
-- 10. INSERT ORDER ITEMS DATA
-- Composite key: order_id + product_id
-- ============================================================

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES
(1, 1, 1, 65000),
(1, 3, 1, 79999),
(2, 2, 1, 72000),
(2, 5, 2, 59900),
(3, 4, 1, 79900),
(3, 7, 1, 29990),
(4, 6, 1, 46900),
(5, 8, 1, 58999),
(6, 9, 2, 32999),
(7, 10, 1, 14999);


-- ============================================================
-- 11. JSONB: SEARCH PRODUCTS BY RAM
-- ============================================================

SELECT product_name,
       specifications->>'ram' AS ram
FROM products
WHERE specifications->>'ram' = '16GB';


-- ============================================================
-- 12. JSONB: SEARCH PRODUCTS BY COLOR
-- ============================================================

SELECT product_name,
       specifications->>'color' AS color
FROM products
WHERE specifications->>'color' = 'Black';


-- ============================================================
-- 13. JSONB: SEARCH PRODUCTS BY STORAGE
-- ============================================================

SELECT product_name,
       specifications->>'storage' AS storage
FROM products
WHERE specifications->>'storage' = '512GB SSD';


-- ============================================================
-- 14. JSONB: SEARCH PRODUCTS BY WARRANTY
-- ============================================================

SELECT product_name,
       specifications->>'warranty' AS warranty
FROM products
WHERE specifications->>'warranty' = '2 Years';


-- ============================================================
-- 15. ARRAY: SEARCH PRODUCTS BY TAG
-- ============================================================

SELECT product_name,
       tags
FROM products
WHERE 'gaming' = ANY(tags);


-- ============================================================
-- 16. ARRAY: ADD A NEW TAG
-- ============================================================

UPDATE products
SET tags = array_append(tags, 'featured')
WHERE product_id = 1;


-- ============================================================
-- 17. DATE/TIME: CALCULATE ORDER DURATION
-- ============================================================

SELECT order_id,
       order_date,
       delivery_date,
       delivery_date - order_date AS order_duration
FROM orders;


-- ============================================================
-- 18. DATE/TIME: EXTRACT YEAR AND MONTH
-- ============================================================

SELECT order_id,
       order_date,
       EXTRACT(YEAR FROM order_date) AS order_year,
       EXTRACT(MONTH FROM order_date) AS order_month
FROM orders;


-- ============================================================
-- 19. DATE/TIME: CALCULATE AGE OF ORDERS
-- ============================================================

SELECT order_id,
       order_date,
       AGE(CURRENT_DATE, order_date) AS order_age
FROM orders;


-- ============================================================
-- 20. DATE/TIME: TRUNCATE ORDER TIMESTAMP
-- ============================================================

SELECT order_id,
       order_timestamp,
       DATE_TRUNC('day', order_timestamp) AS order_day
FROM orders;


-- ============================================================
-- 21. DATE/TIME: FORMAT ORDER TIMESTAMP
-- ============================================================

SELECT order_id,
       TO_CHAR(order_timestamp, 'DD-MM-YYYY HH24:MI:SS') AS formatted_timestamp
FROM orders;


-- ============================================================
-- 22. JOIN: DISPLAY PRODUCT, CATEGORY AND ORDER DETAILS
-- ============================================================

SELECT p.product_name,
       c.category_name,
       oi.quantity,
       oi.unit_price
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories c
    ON p.category_id = c.category_id;


-- ============================================================
-- 23. TRANSACTION: BEGIN AND COMMIT
-- Reduces the price of product 1 by 1000
-- ============================================================

BEGIN;

UPDATE products
SET price = price - 1000
WHERE product_id = 1;

COMMIT;


-- ============================================================
-- 24. TRANSACTION: BEGIN AND ROLLBACK
-- The price increase is cancelled using ROLLBACK
-- ============================================================

BEGIN;

UPDATE products
SET price = price + 5000
WHERE product_id = 2;

ROLLBACK;


-- ============================================================
-- 25. TRANSACTION: SAVEPOINT
-- The second price update is rolled back to the savepoint
-- The first update remains committed
-- ============================================================

BEGIN;

UPDATE products
SET price = price + 2000
WHERE product_id = 3;

SAVEPOINT price_change;

UPDATE products
SET price = price + 3000
WHERE product_id = 3;

ROLLBACK TO SAVEPOINT price_change;

COMMIT;


-- ============================================================
-- 26. FINAL JOIN: DISPLAY COMPLETE ORDER DETAILS
-- ============================================================

SELECT c.customer_name,
       o.order_id,
       p.product_name,
       cat.category_name,
       oi.quantity,
       oi.unit_price,
       o.order_date,
       o.delivery_date
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id
ORDER BY o.order_id;