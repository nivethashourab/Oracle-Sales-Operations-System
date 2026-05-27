--- loads sales_orders table with 5000 rows of data

INSERT INTO sales_orders (
    order_id,
    customer_id,
    order_date,
    status,
    total_amount
)
SELECT
    LEVEL,

    MOD(LEVEL,1000) + 1,

    SYSDATE - DBMS_RANDOM.VALUE(1,365),

    CASE MOD(LEVEL,4)
        WHEN 0 THEN 'PENDING'
        WHEN 1 THEN 'SHIPPED'
        WHEN 2 THEN 'COMPLETED'
        ELSE 'CANCELLED'
    END,

    ROUND(DBMS_RANDOM.VALUE(100,5000),2)

FROM dual
CONNECT BY LEVEL <= 5000;

COMMIT;
