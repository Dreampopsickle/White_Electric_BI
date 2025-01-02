

SELECT
    id AS payment_id,
    created_at AS payment_created_at,
    status AS payment_status,
    source_type AS payment_source,
    CAST(JSON_EXTRACT_SCALAR(amount_money, '$.amount') AS FLOAT64) / 100 AS payment_amount,
    JSON_EXTRACT_SCALAR(amount_money, '$.currency') AS CURRENCY,
    order_id
FROM 
    `we-analysis`.`Sales_Test`.`payments`