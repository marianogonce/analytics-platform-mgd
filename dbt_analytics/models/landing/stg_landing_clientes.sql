{{
config(
materialized = "table",
schema = "landing",
alias = "clientes_csv",
tags = ["landing_quality"]
)
}}
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
'{{ var("landing_clientes_path") }}',
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
{{ normalize_documento("documento") }} as documento_normalizado,
-- Limpiamos textos usando macros.
{{ normalize_text("nombre") }} as nombre,
{{ normalize_text("direccion") }} as direccion,
{{ normalize_text("cp") }} as cp
from archivo_csv
)
select
*
from estandarizado_minimo