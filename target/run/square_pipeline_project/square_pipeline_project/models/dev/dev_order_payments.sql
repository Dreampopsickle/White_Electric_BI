

  create or replace view `we-analysis`.`Sales_Test_dev`.`dev_order_payments`
  OPTIONS()
  as 

WITH order_payments AS (
    SELECT 
        o.order_id,
        o.order_created_at,
        o.total_tax AS order_tax,
        o.total_tip AS order_tip,
        o.order_state,
        p.payment_id,
        p.payment_net_amount,
        p.payment_status,
        p.payment_source
    FROM `we-analysis`.`Sales_Test_staging`.`stg_orders` o
    JOIN `we-analysis`.`Sales_Test_staging`.`stg_payments` p
    ON o.order_id = p.order_id
)

SELECT *
FROM order_payments;

