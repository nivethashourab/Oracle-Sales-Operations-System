SQL> 
SQL> SELECT DBMS_METADATA.GET_DDL('VIEW', view_name)
  2  FROM user_views
  3  ORDER BY view_name;

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SALES_OPS"."VW_
CUSTOMER_ORDER_SUMMARY" ("CUSTOMER_ID",
"CUSTOMER_NAME", "CITY", "TOTAL_ORDERS",
 "TOTAL_SPENT", "AVG_ORDER_VALUE") AS
  SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_na
me,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
LEFT JOIN sales_orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SALES_OPS"."VW_
DAILY_SALES_TREND" ("SALES_DATE", "TOTAL
_ORDERS", "DAILY_REVENUE") AS
  SELECT
    TRUNC(order_date) AS sales_date,
    COUNT(order_id) AS total_orders,
    SUM(total_amount) AS daily_revenue
FROM sales_orders
GROUP BY TRUNC(order_date)
ORDER BY sales_date


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SALES_OPS"."VW_
INVENTORY_STATUS" ("PRODUCT_ID", "PRODUC
T_NAME", "CATEGORY", "STOCK_QTY", "STOCK
_STATUS") AS
  SELECT
    product_id,
    product_name,
    category,
    stock_qty,

    CASE
        WHEN stock_qty < 5 THEN 'CRITICAL'
        WHEN stock_qty < 15 THEN 'LOW'
        ELSE 'SUFFICIENT'
    END AS stock_status

FROM products


  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SALES_OPS"."VW_
PRODUCT_PERFORMANCE" ("PRODUCT_ID", "PRO
DUCT_NAME", "CATEGORY", "TOTAL_QUANTITY_
SOLD", "TOTAL_REVENUE") AS
  SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.unit_price) AS tota
l_revenue
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category

SQL> 
SQL> SPOOL OFF
