# February Sales Report

## Daily Sales Revenue and Total Items Sold

```sales
--- name: daily_sales_summary
SELECT
    CAST(order_created_at AS DATE) AS sales_date,
    SUM(revenue) AS total_revenue,
    SUM(total_items_sold) AS items_sold,
    COUNT(DISTINCT order_id) AS total_orders
FROM we_sales_data.fact_sales
GROUP BY 1
ORDER BY 1
```
