{{ config(materialized='view', enabled=true) }}

WITH order_payments AS (
    SELECT 
        o.order_id AS order_id,
        o.total_tax AS transaction_tax_amount,
        p.payment_id AS transaction_id,
        p.payment_datetime AS transaction_timestamp,
        p.order_amount AS transaction_amount,
        p.order_currency_type AS transaction_currency_type,
        p.tip_amount AS transaction_tip_amount,
        p.tip_currency_type AS transaction_tip_currency_type,
        p.payment_status AS transaction_state,
        p.payment_source AS transaction_source,
        p.application_detail AS transaction_method -- 'SQUARE_POS' == In-store, 'ECOMMERCE_API' == Online, 'OTHER' == Gift card?
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_payments' )}} p
    ON o.order_id = p.order_id
)

SELECT *
FROM order_payments