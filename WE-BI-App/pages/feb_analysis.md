# February Sales Report

## Daily Sales Revenue and Total Items Sold

```sales
SELECT
    order_date,
    SUM(total_sales) AS daily_sales_revenue,
    SUM(total_orders) AS items_sold,
    COUNT(DISTINCT order_id) AS orders_placed
FROM we_sales_data.fact_sales
GROUP BY order_date
ORDER BY order_date;
```

<LineChart 
    data={sales}
    x=order_date
    y=daily_sales_revenue
    yfmt='usd'
    yAxisTitle="Daily Sales"
/>
