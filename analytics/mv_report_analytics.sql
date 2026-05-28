-- Daily Sales Summary
-- Uses: MV_SALES_SUMMARY
SELECT
    sale_date,
    total_orders,
    ROUND(total_sales, 2) AS total_sales
FROM mv_sales_summary
ORDER BY sale_date DESC;

-- Top 10 Customers by Revenue
-- Uses: MV_CUSTOMER_SALES
SELECT
    customer_id,
    orders_count,
    ROUND(lifetime_value, 2) AS lifetime_value
FROM mv_customer_sales
ORDER BY lifetime_value DESC
FETCH FIRST 10 ROWS ONLY;

-- Top 10 Products by Revenue
-- Uses: MV_PRODUCT_SALES
SELECT
    product_id,
    product_name,
    category,
    ROUND(total_revenue, 2) AS total_revenue
FROM mv_product_sales
ORDER BY total_revenue DESC
FETCH FIRST 10 ROWS ONLY;

-- Most Sold Products
-- Uses: MV_PRODUCT_SALES
SELECT
    product_name,
    total_units_sold
FROM mv_product_sales
ORDER BY total_units_sold DESC
FETCH FIRST 10 ROWS ONLY;

-- Revenue by Product Category
-- Uses: MV_CATEGORY_SALES
SELECT
    category,
    ROUND(total_sales, 2) AS category_revenue,
    total_items_sold
FROM mv_category_sales
ORDER BY category_revenue DESC;

-- Average Selling Price by Category
-- Uses: MV_PRODUCT_SALES
SELECT
    category,
    ROUND(AVG(avg_selling_price), 2) AS avg_price
FROM mv_product_sales
GROUP BY category
ORDER BY avg_price DESC;

-- Product Order Distribution
-- Uses: MV_PRODUCT_SALES
SELECT
    product_name,
    total_orders
FROM mv_product_sales
ORDER BY total_orders DESC
FETCH FIRST 15 ROWS ONLY;

-- Order Status Distribution
-- Uses: SALES_ORDERS
-- (Transactional operational KPI — better directly from OLTP)
SELECT
    status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100 /
        (SELECT COUNT(*) FROM sales_orders),
        2
    ) AS percentage
FROM sales_orders
GROUP BY status
ORDER BY total_orders DESC;

-- Revenue Loss from Cancelled Orders
-- Uses: SALES_ORDERS
SELECT
    ROUND(SUM(total_amount), 2) AS cancelled_revenue_loss
FROM sales_orders
WHERE status = 'CANCELLED';

-- Monthly Revenue Trend
-- Uses: MV_MONTHLY_SALES
SELECT
    sales_month,
    total_orders,
    ROUND(total_sales, 2) AS total_sales
FROM mv_monthly_sales
ORDER BY sales_month;

-- Low Performing Products
-- Uses: MV_PRODUCT_SALES
SELECT
    product_name,
    total_revenue
FROM mv_product_sales
ORDER BY total_revenue ASC
FETCH FIRST 10 ROWS ONLY;

-- Inventory Risk Analysis
-- Uses: INVENTORY
SELECT
    p.product_name,
    p.category,
    i.stock_qty
FROM inventory i
JOIN products p
    ON i.product_id = p.product_id
WHERE i.stock_qty < 100
ORDER BY i.stock_qty;

-- Refresh All Materialized Views
ALTER MATERIALIZED VIEW MV_SALES_SUMMARY REFRESH COMPLETE;
ALTER MATERIALIZED VIEW MV_CUSTOMER_SALES REFRESH COMPLETE;
ALTER MATERIALIZED VIEW MV_PRODUCT_SALES REFRESH COMPLETE;
ALTER MATERIALIZED VIEW MV_MONTHLY_SALES REFRESH COMPLETE;
ALTER MATERIALIZED VIEW MV_CATEGORY_SALES REFRESH COMPLETE;

