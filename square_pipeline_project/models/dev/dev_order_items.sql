{{ config(materialized='view', enabled=true) }}

WITH order_items AS (
    SELECT 
        o.order_id,
        o.order_created_at,
        o.total_amount AS order_total,
        li.line_item_id,
        li.item_name,
        li.quantity,
        li.gross_sales,
        li.modifier_name,
        li.modifier_price
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_line_items') }} li
    ON o.order_id = li.order_id
)

SELECT *
FROM order_items

