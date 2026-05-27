---loads order_items table with 20000 rows of data

INSERT INTO order_items (
    item_id,
    order_id,
    product_id,
    quantity,
    unit_price
)
SELECT
    seq_num,

    MOD(seq_num,5000) + 1,

    MOD(seq_num,100) + 1,

    ROUND(DBMS_RANDOM.VALUE(1,10)),

    ROUND(DBMS_RANDOM.VALUE(10,500),2)

FROM (
    SELECT LEVEL AS seq_num
    FROM dual
    CONNECT BY LEVEL <= 20000
);

COMMIT;
