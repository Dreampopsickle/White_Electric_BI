WITH payments AS (
    SELECT
        id AS payment_id,
        created_at AS payment_created_at,
        updated_at as payment_updated_at,
        CAST(json_extract_scalar(amount_money, '$.amount') AS INT64) / 100 AS amount,
        json_extract_scalar(amount_money, '$.currency') AS currency,
        status,
        source_type,
        order_id
    FROM {{ source('raw', 'payments') }}
)

SELECT
    *
FROM
    payments