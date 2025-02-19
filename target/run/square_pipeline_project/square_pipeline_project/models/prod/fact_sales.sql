

  create or replace view `we-analysis`.`Sales_Data_prod`.`fact_sales`
  OPTIONS()
  as 

WITH fact_sales AS (
    SELECT
        payment_id,
        order_id,
        line_item_id,
        CAST(FORMAT_TIMESTAMP('%Y%m%d%H%M%S', order_timestamp) AS INT64) AS date_time_key,
        payment_amount,
        total_collected_amount,
        payment_approved_amount AS approved_amount,
        payment_tip_amount,
        payment_processing_fee,
        order_amount,
        order_tax,
        order_tip,
        order_discount,
        item_base_price,
        item_gross_amount,
        item_total_amount,
        modifier_price
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_payments` 
)

SELECT * FROM fact_sales;

