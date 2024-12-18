{{ config(materialized='view', enabled=true) }}

SELECT
    order_id,
    line_item_uid AS line_item_id,
    item_name,
    CAST(quantity AS INT64) AS quantity,
    gross_sales,
    modifier_name,
    modifier_price
FROM 
    {{ source('raw', 'line_items') }}