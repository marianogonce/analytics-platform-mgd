{{ 
   config( 
       materialized = "view", 
       schema = "bronze", 
       alias = "clientes" 
   ) 
}} 
 -- Modelo bronze. -- Lee todos los Parquet generados por el script Python. 
-- No deduplica ni aplica reglas fuertes de negocio. 
 
with parquet_bronze as ( 
 
   select 
       * 
   from read_parquet( 
       '{{ var("bronze_clientes_glob") }}', 
       union_by_name = true, 
       hive_partitioning = false 
   ) 
 
) 
 
select 
   -- Datos recibidos. 
   cast(tipo_documento as varchar) as tipo_documento, 
   cast(documento as varchar) as documento, 
   cast(documento_normalizado as varchar) as documento_normalizado, 
   cast(nombre as varchar) as nombre, 
   cast(direccion as varchar) as direccion, 
   cast(cp as varchar) as cp, 
 
   -- Metadata técnica. 
   cast(source_file as varchar) as source_file, 
   cast(ingestion_ts as timestamp) as ingestion_ts, 
   cast(ingestion_date as date) as ingestion_date, 
   cast(batch_id as varchar) as batch_id, 
   cast(row_number_in_file as bigint) as row_number_in_file 
 
from parquet_bronze