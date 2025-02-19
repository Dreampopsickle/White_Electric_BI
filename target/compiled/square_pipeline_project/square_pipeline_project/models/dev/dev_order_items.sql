

WITH orders AS (
    SELECT 
        o.order_id AS order_id,
        o.order_datetime AS order_timestamp,
        li.line_item_id AS line_item_id,
        li.item_name AS item_name,
        li.item_quantity AS item_quantity,
        li.modifier_name AS modifier_name
    FROM `we-analysis`.`Sales_Data_staging`.`stg_orders` o
    JOIN `we-analysis`.`Sales_Data_staging`.`stg_line_items` li
    ON o.order_id = li.order_id
)

SELECT *
FROM orders
ORDER BY order_timestamp