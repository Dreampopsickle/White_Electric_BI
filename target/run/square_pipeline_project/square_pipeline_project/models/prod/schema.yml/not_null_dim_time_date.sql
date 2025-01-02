select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select date
from `we-analysis`.`Sales_Test_prod`.`dim_time`
where date is null



      
    ) dbt_internal_test