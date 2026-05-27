SQL> 
SQL> SELECT DBMS_METADATA.GET_DDL('PROCEDURE', object_name)
  2  FROM user_objects
  3  WHERE object_type = 'PROCEDURE'
  4  ORDER BY object_name;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."GENE
RATE_PRODUCT_PERFORMANCE"
AS
BEGIN

    DELETE FROM product_performance_report;


    INSERT INTO product_performance_report
    (
        product_id,
        product_name,
        total_quantity,
        total_revenue,
        report_date
    )
    SELECT
        p.product_id,

        p.product_name,

        SUM(oi.quantity),

        SUM(oi.quantity * oi.unit_price),

        SYSDATE

    FROM order_items oi
    JOIN products p
    ON oi.product_id = p.product_id

    GROUP BY
        p.product_id,
        p.product_name;

    COMMIT;

END;


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."GENE
RATE_SPOOL_SCRIPT"
AS
BEGIN

    FOR obj IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE object_type IN (
            'TABLE',
            'VIEW',
            'PROCEDURE',
            'PACKAGE',
            'TRIGGER'
        )
        ORDER BY object_type, object_name
    )
    LOOP

        DBMS_OUTPUT.PUT_LINE(
            'SPOOL ' || LOWER(obj.object_name)
|| '.sql'
        );

        DBMS_OUTPUT.PUT_LINE(
            'SELECT DBMS_METADATA.GET_DDL('''
            || obj.object_type || ''','''
            || obj.object_name
            || ''') FROM dual;'
        );

        DBMS_OUTPUT.PUT_LINE('SPOOL OFF');

        DBMS_OUTPUT.PUT_LINE('');

    END LOOP;

END;


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."GENE
RATE_STOCK_ALERTS"
AS
BEGIN

    INSERT INTO stock_alerts (
        product_id,
        product_name,
        stock_qty
    )
    SELECT
        product_id,
        product_name,
        stock_qty
    FROM products
    WHERE stock_qty < 10;

    COMMIT;

END;


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."GENE
RATE_TOP_CUSTOMERS"
AS
BEGIN

    DELETE FROM top_customers_report;

    INSERT INTO top_customers_report
    (
        customer_id,
        customer_name,
        total_orders,
        total_spent,
        report_date
    )
    SELECT
        c.customer_id,

        c.first_name || ' ' || c.last_name,

        COUNT(s.order_id),

        SUM(s.total_amount),

        SYSDATE

    FROM customers c
    JOIN sales_orders s
    ON c.customer_id = s.customer_id

    WHERE s.status != 'CANCELLED'

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name;

    COMMIT;

END;


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."GENE
RATE_WEEKLY_SALES_SUMMARY"
AS
BEGIN

    DELETE FROM weekly_sales_summary;

    INSERT INTO weekly_sales_summary
    (
        report_week,
        total_orders,
        total_revenue,
        avg_order_value,
        created_date
    )
    SELECT
        TRUNC(order_date, 'IW') AS report_week,

        COUNT(*) AS total_orders,

        SUM(total_amount) AS total_revenue,

        ROUND(AVG(total_amount), 2) AS avg
_order_value,

        SYSDATE

    FROM sales_orders
    WHERE status != 'CANCELLED'
    GROUP BY TRUNC(order_date, 'IW');

    COMMIT;

END;


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."PROC
ESS_ORDER" (
    p_customer_id   IN NUMBER,
    p_product_id    IN NUMBER,
    p_quantity      IN NUMBER
)
AS
    v_stock         NUMBER;
    v_price         NUMBER;
    v_order_id      NUMBER;
    v_total         NUMBER;
BEGIN

    -- Step 1: Check stock
    SELECT stock_qty, unit_price
    INTO v_stock, v_price
    FROM products
    WHERE product_id = p_product_id;

    -- Step 2: Validate stock
    IF v_stock < p_quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insuf
ficient stock');
    END IF;

    -- Step 3: Create order
    INSERT INTO sales_orders (
        customer_id,
        order_date,
        status,
        total_amount
    )
    VALUES (
        p_customer_id,
        SYSDATE,
        'CREATED',
        0
    )
    RETURNING order_id INTO v_order_id;

    -- Step 4: Insert order item
    INSERT INTO order_items (
        order_id,
        product_id,
        quantity,
        unit_price
    )
    VALUES (
        v_order_id,
        p_product_id,
        p_quantity,
        v_price
    );

    -- Step 5: Calculate total
    v_total := p_quantity * v_price;

    -- Step 6: Update order total
    UPDATE sales_orders
    SET total_amount = v_total
    WHERE order_id = v_order_id;

    -- Step 7: Deduct inventory
    UPDATE products
    SET stock_qty = stock_qty - p_quantity
    WHERE product_id = p_product_id;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Order processed successfully. O
rder ID: ' || v_order_id);

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Product not found');

    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);

END;


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


  CREATE OR REPLACE EDITIONABLE PROCEDURE "SALES_OPS"."UPDA
TE_ORDER_TOTALS"
AS
BEGIN
    UPDATE sales_orders o
    SET total_amount = (
        SELECT NVL(SUM(oi.quantity * oi.un
it_price), 0)
        FROM order_items oi
        WHERE oi.order_id = o.order_id
    );

    COMMIT;
END;

SQL> 
SQL> SPOOL OFF
