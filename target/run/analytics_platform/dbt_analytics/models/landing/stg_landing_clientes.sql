
  
    
    

    create  table
      "warehouse"."landing"."clientes_csv__dbt_tmp"
  
    as (
      
-- Este modelo lee el CSV de landing y crea una tabla validable por dbt.
-- materialized = "table": crea una tabla física.
-- schema = "landing": usa el schema landing.
-- alias = "clientes_csv": el nombre final será landing.clientes_csv.
-- tags: permite agrupar este modelo.
with archivo_csv as (
-- read_csv_auto es una función de DuckDB para leer CSV.
select
*
from read_csv_auto(
'../data/landing/clientes/sample_clientes.csv',
header = true,
all_varchar = true
)
),
estandarizado_minimo as (
select
-- Normalizamos el tipo de documento.
upper(trim(cast(tipo_documento as varchar))) as tipo_documento,
-- Conservamos el documento original.
cast(documento as varchar) as documento,
-- Creamos documento normalizado para tests.

regexp_replace(
cast(documento as varchar),
'[^0-9]',
'',
'g'
) as documento_normalizado,
-- Limpiamos textos usando macros.
nullif(
trim(cast(nombre as varchar)),
''
) as nombre,
nullif(
trim(cast(direccion as varchar)),
''
) as direccion,
nullif(
trim(cast(cp as varchar)),
''
) as cp
from archivo_csv
)
select
*
from estandarizado_minimo
    );
  
  