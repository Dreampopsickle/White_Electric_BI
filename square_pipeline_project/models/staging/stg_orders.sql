{{ config(materialized='view', enabled=true) }}

SELECT
    TRIM(order_id) as order_id,
    created_at AS order_datetime,
    TRIM(state) AS order_state,
    total_money  AS total_order_amount,
    total_tax_money AS total_tax,
    total_tip_money AS total_tip,
    total_discount_money AS total_discount
FROM 
    {{ source('raw', 'orders_data') }}