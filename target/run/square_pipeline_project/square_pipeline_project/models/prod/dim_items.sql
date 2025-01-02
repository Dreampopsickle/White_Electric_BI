

  create or replace view `we-analysis`.`Sales_Test_prod`.`dim_items`
  OPTIONS()
  as 
WITH items AS (
    SELECT 
        DISTINCT line_item_id AS item_id,
        item_name,
        modifier_name,
        modifier_price
    FROM 
        `we-analysis`.`Sales_Test_dev`.`dev_order_items`
)

SELECT * FROM items;

