
    
    

with dbt_test__target as (

  select date as unique_field
  from `we-analysis`.`Sales_Test`.`dim_time`
  where date is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


