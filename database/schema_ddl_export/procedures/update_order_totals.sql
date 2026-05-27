CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."UPDA
TE_ORDER_TOTALS"
AS
BEGIN
    UPDATE sales_orders o
    SET total_amount = (
        SELECT NVL(SUM(oi.quantity * oi.unit_price), 0)
        FROM order_items oi
        WHERE oi.order_id = o.order_id
    );

    COMMIT;
END;
