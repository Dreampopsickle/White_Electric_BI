# February Sales Report

## Daily Sales Revenue and Total Items Sold

```sales
SELECT
    fs.payment_id,
    fs.order_id,
    fs.line_item_id,
    fs.date_time_key,
    dt.timestamp_utc,
    dt.timestamp_est,
    fs.item_quantity,
    fs.item_base_price,
    fs.item_gross_sales,
    fs.order_tax,
    fs.order_tip,
    fs.modifier_price,
    di.modifier_name,
    fs.payment_total
FROM we_sales_data.fact_sales fs
JOIN we_sales_data.dim_time dt
ON fs.date_time_key = dt.date_time_key
JOIN we_sales_data.dim_payments dp
ON fs.payment_id = dp.payment_id
JOIN we_sales_data.dim_items di
ON fs.line_item_id = di.item_id
ORDER BY dt.timestamp_utc
```

<Value
data={sales}
column=timestamp_est
row=6
fmt='H:MM:SS AM/PM'
/>
