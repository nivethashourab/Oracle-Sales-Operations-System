-- Monthly Revenue Trend

SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    SUM(total_amount) AS total_revenue
FROM sales_orders
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

-- Top Customers by Spending

SELECT
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN sales_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- Best Selling Products

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- Best Selling Products

SELECT
    p.product_name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- Order Status Summary

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM sales_orders
GROUP BY order_status
ORDER BY total_orders DESC;
