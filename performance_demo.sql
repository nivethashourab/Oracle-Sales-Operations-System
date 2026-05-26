-- Execution Plan Demonstration

EXPLAIN PLAN FOR
SELECT
    customer_id,
    SUM(total_amount)
FROM sales_orders
GROUP BY customer_id;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Composite Index Query Example

SELECT
    order_id,
    customer_id,
    order_status,
    total_amount
FROM sales_orders
WHERE customer_id = 101
AND order_status = 'DELIVERED';

-- Composite Index Query Example

SELECT
    order_id,
    customer_id,
    order_status,
    total_amount
FROM sales_orders
WHERE customer_id = 101
AND order_status = 'DELIVERED';

-- Revenue Aggregation Query

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS sales_month,
    SUM(total_amount) AS monthly_revenue
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY sales_month;

-- Inventory Lookup Query

SELECT
    product_name,
    stock_quantity
FROM products
WHERE stock_quantity < reorder_level;
