

  create or replace view `we-analysis`.`Sales_Test_prod`.`dim_time`
  OPTIONS()
  as 

WITH dates_and_times AS (
    SELECT 
        DISTINCT TIMESTAMP(order_created_at) AS full_timestamp
    FROM `we-analysis`.`Sales_Test_dev`.`dev_order_items`
),

time_data AS (
    SELECT
        full_timestamp,
        DATE(full_timestamp) AS date_key,
        EXTRACT(YEAR FROM full_timestamp) AS year,
        EXTRACT(MONTH FROM full_timestamp) AS month,
        EXTRACT(DAY FROM full_timestamp) AS day,
        EXTRACT(HOUR FROM full_timestamp) AS hour,
        EXTRACT(MINUTE FROM full_timestamp) AS minute,
        EXTRACT(SECOND FROM full_timestamp) AS second,
        EXTRACT(DAYOFWEEK FROM full_timestamp) AS day_of_week,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM full_timestamp) IN (1, 7) THEN TRUE
            ELSE FALSE
        END AS is_weekend
    FROM dates_and_times
)

SELECT * FROM time_data;

