
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(nombre as varchar)) = ''

  
  
      
    ) dbt_internal_test