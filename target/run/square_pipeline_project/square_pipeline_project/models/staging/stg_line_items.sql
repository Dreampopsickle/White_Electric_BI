

  create or replace view `we-analysis`.`Sales_Test_staging`.`stg_line_items`
  OPTIONS()
  as 

SELECT
    TRIM(order_id) AS order_id,
    TRIM(line_item_uid) AS line_item_id,
    TRIM(item_name) AS item_name,
    CAST(quantity AS INT64) AS item_quantity,
    base_price AS item_base_price,
    gross_sales AS item_gross_sales,
    TRIM(modifier_name) as modifier_name,
    modifier_price
FROM 
    `we-analysis`.`Sales_Test`.`line_items`;

