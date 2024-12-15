

  create or replace view `we-analysis`.`Sales_Test`.`dim_items`
  OPTIONS()
  as WITH item_data as (
    SELECT 
        DISTINCT 
        item_name,
        modifier_name,
        base_price,
        gross_sales
    FROM 
        `we-analysis`.`Sales_Test`.`stg_line_items`
)

SELECT 
    *
FROM 
    item_data;

