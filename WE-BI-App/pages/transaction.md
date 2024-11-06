```sql sales_transactions
select
   strptime(Date, '%m/%d/%Y') as DATE,
   strftime(strptime(Time, '%I:%M:%S %p'), '%I:%M %p') as TIME,
   Transaction_ID as TRANSACTION_ID,
   Category as CATEGORY,
   Item as ITEM,
   cast(Gross_Sales as float) as GROSS_SALES,
   cast(Discounts as float) as DISCOUNTS,
   cast(Net_Sales as float) as NET_SALES

from master_sales.WE_SALES_2024_2025
order by Date
```

```sql sales_by_category
select
    DATE,
    CATEGORY,
    ANY_VALUE(ITEM) AS ITEM,
    sum(NET_SALES) AS NET_SALES
from ${sales_transactions}
WHERE DATE >= '2024-10-01' AND DATE <= '2024-10-31' AND CATEGORY = 'Pastries'
GROUP BY
    DATE,
    CATEGORY

```

<BarChart
data={sales_by_category}
x=DATE
y=NET_SALES
yAxisTitle="Net Sales"
series=ITEM
/>
