

  create or replace view `we-analysis`.`Sales_Test_staging`.`stg_line_items`
  OPTIONS()
  as 

SELECT
    order_id,
    line_item_uid AS line_item_id,
    item_name,
    CAST(quantity AS INT64) AS quantity,
    gross_sales,
    modifier_name,
    modifier_price
FROM 
    `we-analysis`.`Sales_Test`.`line_items`;

