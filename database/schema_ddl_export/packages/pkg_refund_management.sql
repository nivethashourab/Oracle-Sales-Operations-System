CREATE OR REPLACE PACKAGE sales_ops.pkg_refund_management AS

    PROCEDURE process_return (
        p_order_id IN NUMBER
    );

END pkg_refund_management;
/
