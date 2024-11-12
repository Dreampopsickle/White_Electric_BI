<img src="../static/logo.png" alt="logo" class="my-4 size-24" />

```sales
select
    Date AS DATE,
    Time AS TIME,
    Transaction_ID AS TRANSACTION_ID,
    Customer_ID AS CUSTOMER_ID,
    Unit AS UNIT,
    Count AS COUNT,
    Category AS CATEGORY,
    Item AS ITEM,
    CAST(REPLACE(Gross_Sales, '$', '') AS FLOAT) AS GROSS_SALES,
    CAST(REPLACE(Discounts, '$', '') AS FLOAT) AS DISCOUNTS,
    CAST(REPLACE(Net_Sales, '$', '') AS FLOAT) AS NET_SALES,
    CAST(REPLACE(Tax, '$', '') AS FLOAT) AS TAX
from master_sales.may_to_oct_2024_sales
order by DATE
```

```Sept_Total
select
    sum(CASE WHEN DATE >= '2024-09-01' AND DATE < '2024-10-01' THEN NET_SALES ELSE 0 END) AS SEPT_TOTAL
from ${sales}
```

```Oct_Total
select
    sum(CASE WHEN DATE >= '2024-10-01' AND DATE < '2024-11-01' THEN NET_SALES ELSE 0 END) AS SEPT_TOTAL

from ${sales}
```

Total sales for the Month on September: <Value data={Sept_Total} fmt=usd2 />

```Sales_By_Item
select
    monthname(DATE) AS MONTH,
    CATEGORY,
    sum(NET_SALES) AS TOTAL_NET_SALES
from ${sales}
where DATE >= '2024-09-01' AND DATE < '2024-11-01'
group by
    MONTH,
    CATEGORY
```

<BarChart
data={Sales_By_Item}
x=MONTH
y=TOTAL_NET_SALES
yFmt=pct0
series=CATEGORY
type=stacked100
title="Sales By Category" 
/>

Total sales for the Month on October: <Value data={Oct_Total} fmt=usd2 />

```Top_5
select
    ITEM,
    SUM(NET_SALES) AS TOTAL_NET_SALES
from ${sales}
where DATE >= '2024-09-01' AND DATE < '2024-10-01'
group by ITEM
order by TOTAL_NET_SALES DESC
LIMIT 5;
```

<DataTable data={Top_5}>
    <Column id=ITEM title='Menu Item' />
    <Column id=TOTAL_NET_SALES fmt=usd2 contentType=colorscale scaleColor=blue/>
</DataTable>
