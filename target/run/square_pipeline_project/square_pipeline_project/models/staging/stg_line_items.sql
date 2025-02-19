

  create or replace view `we-analysis`.`Sales_Data_staging`.`stg_line_items`
  OPTIONS()
  as 

SELECT
    TRIM(order_id) AS order_id,
    TRIM(line_item_uid) AS line_item_id,
    TRIM(item_name) AS item_name,
    CAST(quantity AS INT64) AS item_quantity,
    CAST(base_price AS FLOAT64) AS item_base_price,
    CAST(gross_sales AS FLOAT64) AS item_gross_sales,
    CAST(total_money AS FLOAT64) AS item_total_amount,
    TRIM(modifier_name) AS modifier_name,
    CAST(modifier_price AS FLOAT64) AS modifier_price
FROM 
    `we-analysis`.`Sales_Data`.`line_items_data`;

