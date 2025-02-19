
WITH dim_items AS (
    SELECT 
        DISTINCT line_item_id,
        item_name,
        modifier_name
    FROM 
        `we-analysis`.`Sales_Data_dev`.`dev_order_items`
)

SELECT * FROM dim_items