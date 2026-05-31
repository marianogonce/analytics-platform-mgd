
  
    
    

    create  table
      "warehouse"."silver"."clientes__dbt_tmp"
  
    as (
       
 -- Silver construye el maestro vigente de clientes. -- Por cada documento normalizado queda una sola fila. 
 
with bronze as ( 
 
   -- ref conecta este modelo con src_bronze_clientes. 
   select 
       * 
   from "warehouse"."bronze"."clientes" 
 
), 
 
ranked as ( 
 
   select 
       -- Clave normalizada del cliente. 
       documento_normalizado as cliente_documento, 
 
       -- Datos del cliente. 
       tipo_documento, 
       documento as documento_original, 
       nombre as cliente_nombre, 
       direccion as cliente_direccion, 
       cp as codigo_postal, 
 
       -- Metadata técnica. 
       source_file, 
       ingestion_ts, 
       ingestion_date, 
       batch_id, 
       row_number_in_file, 
 
       -- Ranking para elegir el registro más reciente. 
       row_number() over ( 
           partition by documento_normalizado 
           order by ingestion_ts desc, row_number_in_file desc 
       ) as rn 
 
   from bronze 
 
) 
 
select 
   cliente_documento, 
   tipo_documento, 
   documento_original, 
   cliente_nombre, 
   cliente_direccion, 
   codigo_postal, 
   source_file, 
   ingestion_ts, 
   ingestion_date, 
   batch_id, 
   row_number_in_file 
 
from ranked 
 
where rn = 1
    );
  
  