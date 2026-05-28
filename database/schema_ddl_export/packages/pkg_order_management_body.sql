CREATE OR REPLACE PACKAGE BODY sales_ops.pkg_order_management AS

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
        FROM inventory
        WHERE product_id = p_product_id;

        IF v_stock < p_quantity THEN
            RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock');
        END IF;
    END check_stock;

    ---------------------------------------------------
    PROCEDURE create_order (
        p_customer_id IN NUMBER,
        p_product_id  IN NUMBER,
        p_quantity    IN NUMBER
    )
    AS
        v_order_id NUMBER;
        v_price    NUMBER;
    BEGIN

        check_stock(p_product_id, p_quantity);

        SELECT unit_price
        INTO v_price
        FROM products
        WHERE product_id = p_product_id;

        v_order_id := sales_orders_seq.NEXTVAL;

        INSERT INTO sales_orders (
            order_id,
            customer_id,
            order_date,
            status,
            total_amount
        )
        VALUES (
            v_order_id,
            p_customer_id,
            SYSDATE,
            'CREATED',
            p_quantity * v_price
        );

        INSERT INTO order_items (
            item_id,
            order_id,
            product_id,
            quantity,
            unit_price
        )
        VALUES (
            order_items_seq.NEXTVAL,
            v_order_id,
            p_product_id,
            p_quantity,
            v_price
        );

        UPDATE inventory
        SET stock_qty = stock_qty - p_quantity,
            last_updated = SYSDATE
        WHERE product_id = p_product_id;

        COMMIT;

    END create_order;

    ---------------------------------------------------
    PROCEDURE update_order_status (
        p_order_id IN NUMBER,
        p_status   IN VARCHAR2
    )
    AS
    BEGIN

        UPDATE sales_orders
        SET status = p_status
        WHERE order_id = p_order_id;

        COMMIT;

    END update_order_status;

    ---------------------------------------------------
    PROCEDURE cancel_order (
        p_order_id IN NUMBER
    )
    AS
    BEGIN

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

        UPDATE sales_orders
        SET status = 'CANCELLED'
        WHERE order_id = p_order_id;

        COMMIT;

    END cancel_order;

END pkg_order_management;
/
