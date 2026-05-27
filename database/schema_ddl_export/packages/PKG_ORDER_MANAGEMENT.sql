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
SQL> SPOOL OFF
