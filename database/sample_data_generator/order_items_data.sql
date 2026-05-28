---loads order_items table with 20000 rows of data

BEGIN

    FOR i IN 1..20000 LOOP

        INSERT INTO order_items (
            item_id,
            order_id,
            product_id,
            quantity,
            unit_price
        )
        VALUES (
            order_items_seq.NEXTVAL,

            -- safely map across existing orders
            100000 + MOD(i,5000) + 1,

            MOD(i,100) + 1,

            TRUNC(DBMS_RANDOM.VALUE(1,5)),

            ROUND(DBMS_RANDOM.VALUE(20,1000),2)
        );

        -- commit in batches (important)
        IF MOD(i,1000)=0 THEN
            COMMIT;
        END IF;

    END LOOP;

    COMMIT;

END;
/
