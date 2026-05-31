{{ 
   config( 
       materialized = "table", 
       schema = "gold", 
       alias = "clientes_por_codigo_postal" 
   ) 
}} 
 -- Gold responde una pregunta de negocio: -- ¿cuántos clientes vigentes hay por código postal? 
 
select 
   codigo_postal, 
   count(*) as cantidad_clientes 
 
from {{ ref("silver_clientes") }} 
 
group by 
   codigo_postal 
 
order by 
   codigo_postal