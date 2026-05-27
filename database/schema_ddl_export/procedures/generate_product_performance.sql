create or replace editionable procedure "SALES_OPS"."GENE
RATE_PRODUCT_PERFORMANCE" as
begin
   delete from product_performance_report;


   insert into product_performance_report (
      product_id,
      product_name,
      total_quantity,
      total_revenue,
      report_date
   )
      select p.product_id,
             p.product_name,
             sum(oi.quantity),
             sum(oi.quantity * oi.unit_price),
             sysdate
        from order_items oi
        join products p
      on oi.product_id = p.product_id
       group by p.product_id,
                p.product_name;

   commit;
end;
