
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(tipo_documento as varchar)) = ''
