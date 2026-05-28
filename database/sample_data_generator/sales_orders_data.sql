--- loads sales_orders table with 5000 rows of data

BEGIN

    FOR i IN 1..5000 LOOP

        INSERT INTO sales_orders (
            order_id,
            customer_id,
            order_date,
            status,
            total_amount
        )
        VALUES (
            sales_orders_seq.NEXTVAL,

            MOD(i, 1000) + 1,

            TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0,365)),

            CASE
                WHEN MOD(i,20)=0 THEN 'CANCELLED'
                WHEN MOD(i,5)=0 THEN 'SHIPPED'
                WHEN MOD(i,3)=0 THEN 'DELIVERED'
                ELSE 'CREATED'
            END,

            0
        );

    END LOOP;

    COMMIT;

END;
/
