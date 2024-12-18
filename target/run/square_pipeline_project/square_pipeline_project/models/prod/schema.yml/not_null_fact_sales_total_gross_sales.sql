select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select total_gross_sales
from `we-analysis`.`Sales_Test`.`fact_sales`
where total_gross_sales is null



      
    ) dbt_internal_test