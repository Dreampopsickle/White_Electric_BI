

WITH dates_and_times AS (
    SELECT 
        DISTINCT TIMESTAMP(order_timestamp) AS full_timestamp
    FROM `we-analysis`.`Sales_Data_dev`.`dev_order_items`
),

time_data AS (
    SELECT
        full_timestamp AS timestamp_utc,
        DATETIME(full_timestamp, "EST") AS timestamp_est,
        CAST(FORMAT_TIMESTAMP('%Y%m%d%H%M%S', full_timestamp) AS INT64) AS date_time_key,
        EXTRACT(YEAR FROM full_timestamp) AS year,
        EXTRACT(MONTH FROM full_timestamp) AS month,
        EXTRACT(DAY FROM full_timestamp) AS day,
        EXTRACT(HOUR FROM DATETIME(full_timestamp, "EST")) AS hour, ---UTC to EST
        EXTRACT(MINUTE FROM full_timestamp) AS minute,
        EXTRACT(SECOND FROM full_timestamp) AS second,
        EXTRACT(DAYOFWEEK FROM full_timestamp) AS day_of_week,
        FORMAT_TIMESTAMP('%A', full_timestamp) AS day_name,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM full_timestamp) IN (1, 7) THEN TRUE
            ELSE FALSE
        END AS is_weekend
    FROM dates_and_times
)

SELECT * FROM time_data