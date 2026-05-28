CREATE OR REPLACE PACKAGE sales_ops.pkg_order_management AS

    PROCEDURE create_order (
        p_customer_id IN NUMBER,
        p_product_id  IN NUMBER,
        p_quantity    IN NUMBER
    );

    PROCEDURE cancel_order (
        p_order_id IN NUMBER
    );

    PROCEDURE update_order_status (
        p_order_id IN NUMBER,
        p_status   IN VARCHAR2
    );

END pkg_order_management;
/
