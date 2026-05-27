--- loads inventory table

INSERT INTO inventory (
    product_id,
    available_stock,
    last_updated
)
SELECT
    product_id,

    ROUND(DBMS_RANDOM.VALUE(50,500)),

    SYSDATE

FROM products;

COMMIT;
