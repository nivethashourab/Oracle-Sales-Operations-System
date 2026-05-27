---loads customers table with 1000 rows of data

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    email,
    phone,
    city,
    country,
    created_date
)
SELECT
    LEVEL,
    'FirstName' || LEVEL,
    'LastName' || LEVEL,
    'customer' || LEVEL || '@mail.com',
    '98765' || TO_CHAR(LEVEL),

    CASE MOD(LEVEL,5)
        WHEN 0 THEN 'Berlin'
        WHEN 1 THEN 'Munich'
        WHEN 2 THEN 'Hamburg'
        WHEN 3 THEN 'Frankfurt'
        ELSE 'Stuttgart'
    END,

    'Germany',

    SYSDATE - DBMS_RANDOM.VALUE(1,365)

FROM dual
CONNECT BY LEVEL <= 1000;

COMMIT;
