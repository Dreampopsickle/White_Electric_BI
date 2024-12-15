

  create or replace view `we-analysis`.`Sales_Test`.`int_order_items`
  OPTIONS()
  as WITH joined_data AS (
    SELECT
        o.order_id,
        o.location_id,
        o.order_created_at,
        o.order_updated_at,
        o.order_state,
        o.total_amount AS order_total_amount,
        o.total_tax,
        o.total_tip,
        li.line_item_uid,
        li.item_name,
        li.quantity,
        li.base_price,
        li.gross_sales,
        li.total_money,
        li.modifier_name,
        li.modifier_price
    FROM `we-analysis`.`Sales_Test`.`stg_orders` o
    LEFT JOIN `we-analysis`.`Sales_Test`.`stg_line_items` li
    ON o.order_id = li.order_id
)

SELECT 
    *
FROM
    joined_data;

