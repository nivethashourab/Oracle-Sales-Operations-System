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
