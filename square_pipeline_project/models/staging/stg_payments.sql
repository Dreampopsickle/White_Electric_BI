{{ config(materialized='view', enabled=true) }}

SELECT
    TRIM(id) AS payment_id,
    created_at AS payment_datetime,
    ROUND(CAST(JSON_EXTRACT_SCALAR(amount_money, '$.amount') AS FLOAT64) / 100, 2) AS order_amount,
    TRIM(JSON_EXTRACT_SCALAR(amount_money, '$.currency')) AS order_currency_type,
    TRIM(status) AS payment_status,
    TRIM(source_type) AS payment_source,
    TRIM(order_id) AS order_id,
    ROUND(CAST(JSON_EXTRACT_SCALAR(processing_fee, '$[0].amount_money.amount') AS FLOAT64) / 100, 2) AS processing_fee,
    TRIM(JSON_EXTRACT_SCALAR(processing_fee, '$[0].amount_money.currency')) AS processing_fee_currency_type,
    ROUND(CAST(JSON_EXTRACT_SCALAR(total_money, '$.amount') AS FLOAT64) / 100, 2) AS total_collected_amount,
    TRIM(JSON_EXTRACT_SCALAR(total_money, '$.currency')) AS total_collected_currency_type,
    ROUND(CAST(JSON_EXTRACT_SCALAR(approved_money, '$.amount') AS FLOAT64) / 100, 2) AS approved_amount,
    TRIM(JSON_EXTRACT_SCALAR(approved_money, '$.currency')) AS approved_currency_type,
    ROUND(CAST(JSON_EXTRACT_SCALAR(tip_money, '$.amount') AS FLOAT64) / 100, 2) AS tip_amount,
    TRIM(JSON_EXTRACT_SCALAR(tip_money, '$.currency')) AS tip_currency_type,
    TRIM(receipt_url) AS receipt_url, 
    TRIM(JSON_EXTRACT_SCALAR(application_details, '$.square_product')) AS application_detail

FROM 
    {{ source('raw', 'payment_data') }}
ORDER BY 
    created_at DESC