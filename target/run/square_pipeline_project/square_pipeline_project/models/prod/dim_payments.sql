

  create or replace view `we-analysis`.`Sales_Data_prod`.`dim_payments`
  OPTIONS()
  as 
WITH payments AS (
    SELECT 
        DISTINCT transaction_id,
        transaction_state,
        transaction_source,
        transaction_method
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_payments`
)

SELECT * FROM payments;

