CREATE MATERIALIZED VIEW MV_SALES_SUMMARY (
    category,
    total_sales
)
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;

CREATE MATERIALIZED VIEW MV_CATEGORY_SALES (
    category,
    total_sales,
    total_items_sold
)
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    p.category,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    SUM(oi.quantity) AS total_items_sold
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY p.category;

CREATE MATERIALIZED VIEW MV_CUSTOMER_SALES (
    customer_id,
    customer_name,
    total_spent,
    total_orders
)
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.total_amount) AS total_spent,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN sales_orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name;

CREATE MATERIALIZED VIEW MV_MONTHLY_SALES (
    sales_month,
    total_orders,
    monthly_revenue
)
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS monthly_revenue
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM');
