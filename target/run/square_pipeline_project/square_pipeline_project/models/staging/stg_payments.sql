

  create or replace view `we-analysis`.`Sales_Data_staging`.`stg_payments`
  OPTIONS()
  as 

SELECT
    TRIM(id) AS payment_id,
    created_at AS payment_datetime,
    CAST(JSON_EXTRACT_SCALAR(amount_money, '$.amount') AS FLOAT64) / 100 AS order_amount,
    TRIM(JSON_EXTRACT_SCALAR(amount_money, '$.currency')) AS order_currency_type,
    CAST(JSON_EXTRACT_SCALAR(total_money, '$.amount') AS FLOAT64) / 100 AS total_paid_amount,
    TRIM(JSON_EXTRACT_SCALAR(total_money, '$.currency')) AS total_paid_currency_type,
    CAST(JSON_EXTRACT_SCALAR(tip_money, '$.amount') AS FLOAT64) / 100 AS tip_amount,
    TRIM(JSON_EXTRACT_SCALAR(tip_money, '$.currency')) AS tip_currency_type,
    TRIM(status) AS payment_status,
    TRIM(source_type) AS payment_source,
    TRIM(order_id) AS order_id,
    TRIM(JSON_EXTRACT_SCALAR(application_details, '$.square_product')) AS application_detail,
    TRIM(receipt_url) AS receipt_url
FROM 
    `we-analysis`.`Sales_Data`.`payment_data`;

