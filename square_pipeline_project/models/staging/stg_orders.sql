{{ config(materialized='view', enabled=true) }}

SELECT
    TRIM(order_id) as order_id,
    created_at AS order_datetime,
    TRIM(state) AS order_state,
    CAST(total_money AS FLOAT64) / 100 AS total_order_amount,
    CAST(total_tax_money AS FLOAT64) / 100 AS total_tax,
    CAST(total_tip_money AS FLOAT64) / 100 AS total_tip,
    CAST(total_discount_money AS FLOAT64) / 100 AS total_discount
FROM 
    {{ source('raw', 'orders_data') }}