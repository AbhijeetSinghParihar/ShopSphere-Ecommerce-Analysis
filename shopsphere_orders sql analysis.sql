use shopsphere;
select * from orders_raw;
describe orders_raw;
CREATE TABLE orders (
    row_id INT,
    order_id VARCHAR(30),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(30),
    customer_id VARCHAR(30),
    customer_name VARCHAR(100),
    segment VARCHAR(30),
    country_region VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(30),
    product_id VARCHAR(30),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2)
);

INSERT INTO orders
SELECT
    CAST(CAST(row_id AS DECIMAL(10,2)) AS UNSIGNED),
    order_id,
    STR_TO_DATE(order_date, '%m/%d/%Y'),
    STR_TO_DATE(ship_date, '%m/%d/%Y'),
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country_region,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    CAST(sales AS DECIMAL(15,2)),
    CAST(quantity AS UNSIGNED),
    CAST(REPLACE(discount, '%', '') AS DECIMAL(5,2)),
    CAST(profit AS DECIMAL(15,2))
FROM orders_raw;
select * from orders;
SELECT
    COUNT(*) AS total_rows,
    COUNT(row_id) AS row_id_filled,
    COUNT(order_date) AS order_date_filled,
    COUNT(ship_date) AS ship_date_filled,
    COUNT(sales) AS sales_filled,
    COUNT(quantity) AS quantity_filled,
    COUNT(profit) AS profit_filled
FROM orders;
SELECT SUM(sales) AS total_revenue FROM orders;
SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;
SELECT COUNT(DISTINCT customer_id) AS total_customers,
 SUM(quantity) AS total_units_sold,
 SUM(profit) AS total_profit 
 FROM orders;
 SELECT (SUM(profit) / SUM(sales)) * 100 AS profit_margin
FROM orders;
SELECT SUM(sales) / COUNT(DISTINCT order_id) AS average_order_value FROM orders;
SELECT category,
SUM(sales) AS total_revenue
 FROM orders GROUP BY category ORDER BY total_revenue DESC;
 SELECT category, 
 SUM(profit) AS total_profit
 FROM orders GROUP BY category ORDER BY total_profit DESC;
SELECT category,
 SUM(profit) / SUM(sales) * 100 
 AS profit_margin FROM orders GROUP BY category ORDER BY profit_margin DESC;
SELECT sub_category,
SUM(profit) / SUM(sales) * 100 
AS profit_margin FROM orders GROUP BY sub_category ORDER BY profit_margin ASC;
SELECT region, 
SUM(sales) AS revenue,
 SUM(profit) AS profit 
 FROM orders GROUP BY region ORDER BY revenue DESC;
SELECT
    region,
    SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM orders GROUP BY region ORDER BY profit_margin DESC;

SELECT
YEAR(order_date) AS year,
MONTH(order_date) AS month,
SUM(sales) AS revenue 
    FROM orders GROUP BY YEAR(order_date), MONTH(order_date) ORDER BY year, month;
SELECT
    YEAR(order_date) AS year,
    SUM(sales) AS revenue
FROM orders GROUP BY YEAR(order_date) ORDER BY year;

SELECT
    customer_id,
    customer_name,
    SUM(sales) AS revenue
FROM orders GROUP BY customer_id, customer_name ORDER BY revenue DESC LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count
    FROM orders
    GROUP BY customer_id)
SELECT COUNT(*) AS repeat_customers
FROM customer_orders WHERE order_count > 1;

SELECT product_id,
    product_name,
    SUM(sales) AS revenue
FROM orders GROUP BY product_id, product_name ORDER BY revenue DESC LIMIT 10;
SELECT product_id,
    product_name,
    SUM(sales) AS revenue,
    SUM(profit) AS profit
FROM orders GROUP BY product_id, product_name HAVING SUM(profit) < 0 ORDER BY profit ASC ;
SELECT discount,
COUNT(*) AS order_lines,
SUM(sales) AS revenue,
SUM(profit) AS profit
FROM orders GROUP BY discount ORDER BY discount;
SELECT discount,
SUM(sales) AS revenue,
SUM(profit) AS profit,
SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM orders GROUP BY discount ORDER BY discount ASC;

SELECT category,
    discount,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM orders GROUP BY category, discount ORDER BY category, discount;
SELECT order_id,
    customer_name,
    product_name,
    sales,
    discount,
    profit
FROM orders ORDER BY profit ASC LIMIT 20;
SELECT segment,
SUM(sales) AS revenue,
SUM(profit) AS profit,
SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM orders
GROUP BY segment
ORDER BY revenue DESC;

SELECT
    ship_mode,
    SUM(sales) AS revenue,
    SUM(profit) AS profit,
    SUM(profit) / SUM(sales) * 100 AS profit_margin
FROM orders
GROUP BY ship_mode
ORDER BY revenue DESC;