-- Recalculate total_amount on sales_orders from order_items
MERGE INTO sales_orders so
USING (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS total_amount
    FROM order_items
    GROUP BY order_id
) oi
ON (so.order_id = oi.order_id)
WHEN MATCHED THEN
    UPDATE SET so.total_amount = oi.total_amount;


-- Rebuild inventory quantities based on non-cancelled order consumption.
-- This assumes the current inventory record reflects the initial available stock
-- before order fulfillment, so the script subtracts committed order quantities.
MERGE INTO inventory i
USING (
    SELECT
        oi.product_id,
        GREATEST(inv.stock_qty - SUM(oi.quantity), 0) AS rebuilt_stock
    FROM order_items oi
    JOIN sales_orders so
        ON oi.order_id = so.order_id
    JOIN inventory inv
        ON inv.product_id = oi.product_id
    WHERE so.status <> 'CANCELLED'
    GROUP BY oi.product_id, inv.stock_qty
) s
ON (i.product_id = s.product_id)
WHEN MATCHED THEN
    UPDATE SET
        i.stock_qty = s.rebuilt_stock,
        i.last_updated = SYSDATE;
