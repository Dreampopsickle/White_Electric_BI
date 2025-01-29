

WITH fact_sales AS (
    SELECT
        op.transaction_id,
        op.order_id,
        oi.line_item_id,
        CAST(FORMAT_TIMESTAMP('%Y%m%d%H%M%S', oi.order_timestamp) AS INT64) AS date_time_key,
        oi.item_quantity,
        oi.item_base_price,
        oi.item_gross_amt,
        op.transaction_tax_amount,
        op.transaction_tip_amount,
        oi.modifier_price,
        op.transaction_amount AS payment_total
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_payments` op
    JOIN `we-analysis`.`Sales_Data_dev`.`dev_order_items` oi
    ON op.order_id = oi.order_id
)

SELECT * FROM fact_sales