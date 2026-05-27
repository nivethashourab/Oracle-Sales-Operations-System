 or replace editionable procedure "SALES_OPS"."PROC
ESS_ORDER" (
   p_customer_id in number,
   p_product_id  in number,
   p_quantity    in number
) as
   v_stock    number;
   v_price    number;
   v_order_id number;
   v_total    number;
begin

    -- Step 1: Check stock
   select stock_qty,
          unit_price
     into
      v_stock,
      v_price
     from products
    where product_id = p_product_id;

    -- Step 2: Validate stock
   if v_stock < p_quantity then
      raise_application_error(
         -20001,
         'Insuf
ficient stock'
      );
   end if;

    -- Step 3: Create order
   insert into sales_orders (
      customer_id,
      order_date,
      status,
      total_amount
   ) values ( p_customer_id,
              sysdate,
              'CREATED',
              0 ) returning order_id into v_order_id;

    -- Step 4: Insert order item
   insert into order_items (
      order_id,
      product_id,
      quantity,
      unit_price
   ) values ( v_order_id,
              p_product_id,
              p_quantity,
              v_price );

    -- Step 5: Calculate total
   v_total := p_quantity * v_price;

    -- Step 6: Update order total
   update sales_orders
      set
      total_amount = v_total
    where order_id = v_order_id;

    -- Step 7: Deduct inventory
   update products
      set
      stock_qty = stock_qty - p_quantity
    where product_id = p_product_id;

   commit;
   dbms_output.put_line('Order processed successfully. O
rder ID: ' || v_order_id);
exception
   when no_data_found then
      dbms_output.put_line('Product not found');
   when others then
      rollback;
      dbms_output.put_line(sqlerrm);
end;
