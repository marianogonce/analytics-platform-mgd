 
 -- Gold responde una pregunta de negocio: -- ¿cuántos clientes vigentes hay por código postal? 
 
select 
   codigo_postal, 
   count(*) as cantidad_clientes 
 
from "warehouse"."silver"."clientes" 
 
group by 
   codigo_postal 
 
order by 
   codigo_postal