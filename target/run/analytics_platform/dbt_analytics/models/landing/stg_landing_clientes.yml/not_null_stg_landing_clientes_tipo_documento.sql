
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select tipo_documento
from "warehouse"."landing"."clientes_csv"
where tipo_documento is null



  
  
      
    ) dbt_internal_test