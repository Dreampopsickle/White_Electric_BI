{{ config(materialized='view', enabled=true) }}

WITH order_items AS (
    SELECT 
        o.order_id AS order_id,
        o.order_datetime AS order_timestamp,
        o.total_order_amount AS order_total_amt,
        o.total_tax AS order_total_tax,
        o.total_tip AS order_total_tip,
        o.total_discount AS order_total_discount,
        li.line_item_id AS line_item_id,
        li.item_name AS item_name,
        li.item_quantity AS item_quantity,
        li.item_base_price AS item_base_price,
        li.item_gross_sales AS item_gross_amt,
        li.modifier_name AS modifier_name,
        li.modifier_price AS modifier_price
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_line_items') }} li
    ON o.order_id = li.order_id
)

SELECT *
FROM order_items

