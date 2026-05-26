SQL> 
SQL> SELECT DBMS_METADATA.GET_DDL('PACKAGE', object_name)
  2  FROM user_objects
  3  WHERE object_type = 'PACKAGE'
  4  ORDER BY object_name;

  CREATE OR REPLACE EDITIONABLE PACKAGE "SALES_OPS"."PKG_OR
DER_MANAGEMENT" AS

    PROCEDURE create_order (
        p_customer_id   IN NUMBER,
        p_product_id    IN NUMBER,
        p_quantity      IN NUMBER
    );

    PROCEDURE update_order_total (
        p_order_id IN NUMBER
    );

    PROCEDURE check_stock (
        p_product_id IN NUMBER,
        p_quantity   IN NUMBER
    );

    PROCEDURE cancel_order (
        p_order_id IN NUMBER
    );

END pkg_order_management;
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SALES_OPS"."
PKG_ORDER_MANAGEMENT" AS

    --------------------------------------------------
-
    -- CHECK STOCK
    ---------------------------------------------------
    PROCEDURE check_stock (
        p_product_id IN NUMBER,
        p_quantity   IN NUMBER
    )
    AS
        v_stock NUMBER;
    BEGIN

        SELECT stock_qty
        INTO v_stock
        FROM products
        WHERE product_id = p_product_id;

        IF v_stock < p_quantity THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'Insufficient stock available'
            );
        END IF;

    END check_stock;

    ---------------------------------------------------

    -- CREATE ORDER
    ---------------------------------------------------
    PROCEDURE create_order (
        p_customer_id   IN NUMBER,
        p_product_id    IN NUMBER,
        p_quantity      IN NUMBER
    )
    AS
        v_order_id NUMBER;
        v_price    NUMBER;
    BEGIN

        -- Validate stock
        check_stock(p_product_id, p_quantity);


        -- Get product price
        SELECT unit_price
        INTO v_price
        FROM products
        WHERE product_id = p_product_id;


        -- Create order
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


        -- Insert order item
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

        -- Update total
        update_order_total(v_order_id);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Order created successfully. Order ID: '
            || v_order_id
        );

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END create_order;

    -------------------------------------
--------------
    -- UPDATE ORDER TOTAL
    ---------------------------------------------------
    PROCEDURE update_order_total (
        p_order_id IN NUMBER
    )
    AS
        v_total NUMBER;
    BEGIN

        SELECT SUM(quantity * unit_price)
        INTO v_total
        FROM order_items
        WHERE order_id = p_order_id;

        UPDATE sales_orders
        SET total_amount = v_total
        WHERE order_id = p_order_id;

    END update_order_total;

    ---------------------------------------------------

    -- CANCEL ORDER
    ---------------------------------------------------
    PROCEDURE cancel_order (
        p_order_id IN NUMBER
    )
    AS
    BEGIN

        UPDATE sales_orders
        SET status = 'CANCELLED'
        WHERE order_id = p_order_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE(
            'Order cancelled successfully'
        );

    END cancel_order;

END pkg_order_management;

SQL> 
SQL> SPOOL OFF
