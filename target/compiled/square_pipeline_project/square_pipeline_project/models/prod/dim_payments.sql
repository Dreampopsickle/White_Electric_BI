
WITH payments AS (
    SELECT 
        DISTINCT payment_id,
        payment_status,
        payment_source
    FROM `we-analysis`.`Sales_Test_dev`.`dev_order_payments`
)

SELECT * FROM payments