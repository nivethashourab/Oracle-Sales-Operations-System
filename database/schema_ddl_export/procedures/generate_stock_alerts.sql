create or replace editionable procedure "SALES_OPS"."GENE
RATE_STOCK_ALERTS" as
begin
   insert into stock_alerts (
      product_id,
      product_name,
      stock_qty
   )
      select product_id,
             product_name,
             stock_qty
        from products
       where stock_qty < 10;

   commit;
end;
