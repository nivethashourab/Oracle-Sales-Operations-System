CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."UPDA
TE_INVENTORY"
AS
BEGIN
    UPDATE products p
    SET stock_qty = stock_qty - (
        SELECT NVL(SUM(oi.quantity), 0)
        FROM order_items oi
        WHERE oi.product_id = p.product_id
    );

    COMMIT;
END;
