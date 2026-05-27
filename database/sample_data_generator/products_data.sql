---  loads product table with 500 rows of sample data

INSERT INTO products (
    product_id,
    product_name,
    category,
    unit_price,
    stock_qty,
    created_date
)
SELECT
    LEVEL,

    'Product_' || LEVEL,

    CASE MOD(LEVEL,5)
        WHEN 0 THEN 'Electronics'
        WHEN 1 THEN 'Books'
        WHEN 2 THEN 'Clothing'
        WHEN 3 THEN 'Furniture'
        ELSE 'Groceries'
    END,

    ROUND(DBMS_RANDOM.VALUE(10,500),2),

    ROUND(DBMS_RANDOM.VALUE(50,500)),

    SYSDATE - DBMS_RANDOM.VALUE(1,365)

FROM dual
CONNECT BY LEVEL <= 100;

COMMIT;
