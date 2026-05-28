CREATE OR REPLACE PROCEDURE sales_ops.process_return (
    p_order_id IN NUMBER
)
AS
BEGIN
    -- restore inventory
    UPDATE inventory i
    SET i.stock_qty = i.stock_qty + (
        SELECT oi.quantity
        FROM order_items oi
        WHERE oi.order_id = p_order_id
          AND oi.product_id = i.product_id
    ),
    i.last_updated = SYSDATE
    WHERE EXISTS (
        SELECT 1
        FROM order_items oi
        WHERE oi.order_id = p_order_id
          AND oi.product_id = i.product_id
    );
    -- mark returned
    UPDATE sales_orders
    SET status = 'RETURNED'
    WHERE order_id = p_order_id;
    COMMIT;
END;
/
