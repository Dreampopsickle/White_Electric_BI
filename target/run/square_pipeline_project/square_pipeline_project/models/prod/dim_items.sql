

  create or replace view `we-analysis`.`Sales_Data_prod`.`dim_items`
  OPTIONS()
  as 
WITH items AS (
    SELECT 
        DISTINCT line_item_id AS item_id,
        item_name,
        modifier_name
    FROM 
        `we-analysis`.`Sales_Data_dev`.`dev_order_items`
)

SELECT * FROM items;

