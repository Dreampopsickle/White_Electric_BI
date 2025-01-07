{{ config(materialized='view', enabled=true) }}

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
    {{ source('raw', 'line_items') }}