from __future__ import annotations 
# datetime permite generar timestamps y batch_id. 
from datetime import datetime 
# Path permite manejar rutas de forma portable. 
from pathlib import Path 
 
# duckdb permite conectarnos a la base local. 
import duckdb 
 
 
# Ruta del archivo DuckDB. 
WAREHOUSE_PATH = Path("db/warehouse.duckdb") 
 
# Tabla creada por dbt en landing. 
LANDING_RELATION = "landing.clientes_csv" 
 
 
def run() -> str: 
   """ 
   Genera un archivo Parquet en bronze 
   a partir de la tabla landing ya validada. 
   """ 
 
   # Archivo CSV original. 
   source_file = Path("data/landing/clientes/sample_clientes.csv") 
 
   # Validamos que exista el CSV. 
   if not source_file.exists(): 
       raise FileNotFoundError(f"No existe el archivo: {source_file}") 
 
   # Validamos que exista DuckDB. 
   if not WAREHOUSE_PATH.exists(): 
       raise FileNotFoundError( 
           f"No existe la base: {WAREHOUSE_PATH}. " 
           "Primero ejecutá dbt run y dbt test." 
       ) 
 
   # Generamos fecha y batch_id. 
   now = datetime.now() 
   ingestion_date = now.strftime("%Y-%m-%d") 
   batch_id = now.strftime("batch_%Y%m%d_%H%M%S") 
 
   # Carpeta bronze particionada por fecha. 
   bronze_dir = Path(f"data/bronze/clientes/ingestion_date={ingestion_date}") 
   bronze_dir.mkdir(parents=True, exist_ok=True) 
 
   # Archivo Parquet del lote. 
   bronze_file = bronze_dir / f"{batch_id}.parquet" 
 
   # Abrimos conexión a DuckDB. 
   con = duckdb.connect(str(WAREHOUSE_PATH)) 
 
   try: 
       # Verificamos que exista landing.clientes_csv. 
       table_exists = con.execute( 
           """ 
           select count(*) 
           from information_schema.tables 
           where table_schema = 'landing' 
             and table_name = 'clientes_csv' 
           """ 
       ).fetchone()[0] 
 
       if table_exists == 0: 
           raise RuntimeError( 
               f"No existe {LANDING_RELATION}. " 
               "Primero ejecutá dbt run y dbt test." 
           ) 
 
       # Escribimos el Parquet bronze. 
       # Conservamos datos y agregamos metadata técnica. 
       sql = f""" 
       COPY ( 
           SELECT 
               tipo_documento, 
               documento, 
               documento_normalizado, 
               nombre, 
               direccion, 
               cp, 
               '{source_file.name}' AS source_file, 
               current_timestamp AS ingestion_ts, 
               current_date AS ingestion_date, 
               '{batch_id}' AS batch_id, 
               row_number() OVER () AS row_number_in_file 
           FROM {LANDING_RELATION} 
       ) 
       TO '{bronze_file.as_posix()}' 
       (FORMAT parquet); 
       """ 
 
       con.execute(sql) 
 
   finally: 
       # Cerramos la conexión. 
       con.close() 
 
   return bronze_file.as_posix() 
 
 
def main() -> None: 
   """ 
   Entrada cuando ejecutamos el script desde terminal. 
   """ 
   bronze_file = run() 
   print(f"Archivo bronze generado: {bronze_file}") 
 
 
if __name__ == "__main__": 
   main()