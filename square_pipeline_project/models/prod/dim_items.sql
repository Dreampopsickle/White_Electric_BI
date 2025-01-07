{{ config(materialized='view', enabled=true) }}
WITH items AS (
    SELECT 
        DISTINCT line_item_id AS item_id,
        item_name,
        modifier_name
    FROM 
        {{ ref('dev_order_items') }}
)

SELECT * FROM items
