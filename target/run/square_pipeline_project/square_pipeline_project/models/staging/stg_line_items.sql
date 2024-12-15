

  create or replace view `we-analysis`.`Sales_Test`.`stg_line_items`
  OPTIONS()
  as with line_items AS (
    SELECT
        order_id, 
        line_item_uid,
        item_name,
        CAST(quantity AS INT64) AS quantity,
        CAST(base_price AS FLOAT64) AS base_price,
        CAST(gross_sales AS FLOAT64) AS gross_sales, 
        CAST(total_money AS FLOAT64) AS total_money,
        modifier_name,
        CAST(modifier_price AS FLOAT64) as modifier_price
    FROM `we-analysis`.`Sales_Test`.`line_items`
)

SELECT 
    *
FROM
    line_items;

