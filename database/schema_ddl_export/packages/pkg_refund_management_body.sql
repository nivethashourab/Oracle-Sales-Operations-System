CREATE OR REPLACE PACKAGE BODY sales_ops.pkg_refund_management AS

    PROCEDURE process_return (
        p_order_id IN NUMBER
    )
    AS
    BEGIN

        -- Restore inventory fully
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

        -- Mark order as RETURNED
        UPDATE sales_orders
        SET status = 'RETURNED'
        WHERE order_id = p_order_id;

        COMMIT;

    END process_return;

END pkg_refund_management;
/
