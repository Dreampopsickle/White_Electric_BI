

  create or replace view `we-analysis`.`Sales_Test`.`dim_time`
  OPTIONS()
  as -- Generate a range of timestamps for the time dimension
WITH base_time AS (
    SELECT 
        TIMESTAMP_ADD(
            TIMESTAMP('1970-01-01'), 
            INTERVAL seq * 15 MINUTE
        ) AS datetime
    FROM 
        UNNEST(GENERATE_ARRAY(0, 525600, 1)) AS seq -- Adjust the range for desired time coverage
),
time_components AS (
    SELECT 
        datetime,
        DATE(datetime) AS date,
        EXTRACT(YEAR FROM datetime) AS year,
        EXTRACT(QUARTER FROM datetime) AS quarter,
        EXTRACT(MONTH FROM datetime) AS month,
        FORMAT_TIMESTAMP('%B', datetime) AS month_name,
        EXTRACT(WEEK FROM datetime) AS week,
        EXTRACT(DAY FROM datetime) AS day,
        FORMAT_TIMESTAMP('%A', datetime) AS day_name,
        EXTRACT(DAYOFWEEK FROM datetime) AS day_of_week, -- 1 (Sunday) to 7 (Saturday)
        EXTRACT(HOUR FROM datetime) AS hour,
        EXTRACT(MINUTE FROM datetime) AS minute,
        EXTRACT(SECOND FROM datetime) AS second,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM datetime) IN (1, 7) THEN TRUE
            ELSE FALSE
        END AS is_weekend
    FROM 
        base_time
)
SELECT
    *,
    CONCAT(
        CAST(year AS STRING), 
        '-', LPAD(CAST(month AS STRING), 2, '0'), 
        '-', LPAD(CAST(day AS STRING), 2, '0')
    ) AS date_key -- Useful for joins
FROM
    time_components;

