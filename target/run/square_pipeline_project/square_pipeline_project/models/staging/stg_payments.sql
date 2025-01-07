

  create or replace view `we-analysis`.`Sales_Test_staging`.`stg_payments`
  OPTIONS()
  as 

SELECT
    TRIM(id) AS payment_id,
    created_at AS payment_created_at,
    TRIM(status) AS payment_status,
    TRIM(source_type) AS payment_source,
    CAST(JSON_EXTRACT_SCALAR(amount_money, '$.amount') AS FLOAT64) / 100 AS payment_net_amount,
    TRIM(JSON_EXTRACT_SCALAR(amount_money, '$.currency')) AS currency_type,
    TRIM(order_id) AS order_id
FROM 
    `we-analysis`.`Sales_Test`.`payments`;

