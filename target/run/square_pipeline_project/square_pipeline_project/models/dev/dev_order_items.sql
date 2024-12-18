

  create or replace view `we-analysis`.`Sales_Test_dev`.`dev_order_items`
  OPTIONS()
  as 

WITH order_items AS (
    SELECT 
        o.order_id,
        o.order_created_at,
        o.total_amount AS order_total,
        li.line_item_id,
        li.item_name,
        li.quantity,
        li.gross_sales,
        li.modifier_name,
        li.modifier_price
    FROM `we-analysis`.`Sales_Test_staging`.`stg_orders` o
    JOIN `we-analysis`.`Sales_Test_staging`.`stg_line_items` li
    ON o.order_id = li.order_id
)

SELECT *
FROM order_items;

