
    
    

with dbt_test__target as (

  select item_id as unique_field
  from `we-analysis`.`Sales_Test_prod`.`dim_items`
  where item_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


