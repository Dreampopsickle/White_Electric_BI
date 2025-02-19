{{ config(materialized='view', enabled=true) }}

WITH payments AS (
    SELECT 
        p.payment_id AS payment_id,
        p.order_id AS order_id,
        li.line_item_id AS line_item_id,
        p.payment_datetime AS payment_timestamp,
        p.payment_status AS payment_status,
        p.payment_source AS payment_source,
        p.order_amount AS payment_amount,
        p.total_collected_amount AS total_collected_amount,
        p.approved_amount AS payment_approved_amount,
        p.tip_amount AS payment_tip_amount,
        p.processing_fee AS payment_processing_fee,
        p.receipt_url AS payment_receipt_url,
        p.application_detail AS application_detail, -- 'SQUARE_POS' == In-store, 'ECOMMERCE_API' == Online, 'OTHER' == Gift card?
        o.order_datetime AS order_timestamp,
        o.order_state AS order_state,
        o.total_order_amount AS order_amount,
        o.total_tax AS order_tax,
        o.total_tip AS order_tip,
        o.total_discount AS order_discount,
        li.item_base_price AS item_base_price,
        li.item_gross_sales AS item_gross_amount,
        li.item_total_amount AS item_total_amount,
        li.modifier_price AS modifier_price
    FROM {{ ref('stg_payments') }} p
    JOIN {{ ref('stg_orders' ) }} o
    ON p.order_id = o.order_id
    JOIN {{ ref('stg_line_items' ) }} li
    ON p.order_id = li.order_id
)

SELECT *
FROM payments
ORDER BY payment_timestamp DESC