

WITH order_items AS (
    SELECT 
        order_id,
        line_item_id AS item_id,
        item_name,
        quantity,
        gross_sales AS revenue
   FROM `we-analysis`.`Sales_Test_dev`.`dev_order_items`
)

SELECT * FROM order_items