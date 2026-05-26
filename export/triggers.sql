SQL> 
SQL> SELECT DBMS_METADATA.GET_DDL('TRIGGER', trigger_name)
  2  FROM user_triggers
  3  ORDER BY trigger_name;

  CREATE OR REPLACE EDITIONABLE TRIGGER "SALES_OPS"."TRG_UP
DATE_INVENTORY"
AFTER INSERT ON order_items
FOR EACH ROW
DECLARE
    v_old_stock NUMBER;
BEGIN

    -- Get current stock
    SELECT stock_qty
    INTO v_old_stock
    FROM products
    WHERE product_id = :NEW.product_id;

    -- Update stock
    UPDATE products
    SET stock_qty = stock_qty - :NEW.quantity
    WHERE product_id = :NEW.product_id;

    -- Audit logging
    INSERT INTO inventory_audit (
        product_id,
        old_stock,
        new_stock
    )
    VALUES (
        :NEW.product_id,
        v_old_stock,
        v_old_stock - :NEW.quantity
    );

END;
ALTER TRIGGER "SALES_OPS"."TRG_UPDATE_INVENT
ORY" ENABLE

SQL> 
SQL> SPOOL OFF
