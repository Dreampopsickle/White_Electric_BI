{{ config(materialized='view', enabled=true) }}

WITH order_items AS (
    SELECT 
        order_id,
        line_item_id AS item_id,
        item_name,
        quantity,
        gross_sales AS revenue
   FROM {{ ref('dev_order_items') }}
)

SELECT * FROM order_items