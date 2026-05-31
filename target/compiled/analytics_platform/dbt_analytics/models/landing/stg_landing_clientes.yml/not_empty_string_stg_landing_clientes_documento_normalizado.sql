
select
*
from "warehouse"."landing"."clientes_csv"
where trim(cast(documento_normalizado as varchar)) = ''
