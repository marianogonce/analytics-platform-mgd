
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        tipo_documento as value_field,
        count(*) as n_records

    from "warehouse"."landing"."clientes_csv"
    group by tipo_documento

)

select *
from all_values
where value_field not in (
    'CUIT','DNI'
)



  
  
      
    ) dbt_internal_test