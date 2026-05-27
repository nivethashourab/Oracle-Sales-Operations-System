create or replace editionable procedure "SALES_OPS"."GENE
RATE_TOP_CUSTOMERS" as
begin
   delete from top_customers_report;

   insert into top_customers_report (
      customer_id,
      customer_name,
      total_orders,
      total_spent,
      report_date
   )
      select c.customer_id,
             c.first_name
             || ' '
             || c.last_name,
             count(s.order_id),
             sum(s.total_amount),
             sysdate
        from customers c
        join sales_orders s
      on c.customer_id = s.customer_id
       where s.status != 'CANCELLED'
       group by c.customer_id,
                c.first_name,
                c.last_name;

   commit;
end;
