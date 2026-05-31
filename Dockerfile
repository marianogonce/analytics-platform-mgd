# Dockerfile completo para proyecto dbt + duckdb
FROM python:3.12-slim

# Instala dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Crea usuario no root por seguridad
RUN useradd -ms /bin/bash dbtuser

# Crea directorio de trabajo
WORKDIR /app

# Copia archivos de requerimientos si existen
COPY pyproject.toml ./

# Instala dependencias Python como root
RUN pip install --upgrade pip
RUN pip install --no-cache-dir dbt-core==1.11.9 dbt-duckdb
# Si tienes requirements.txt, descomenta la siguiente línea:
# RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del proyecto
COPY . .

# Cambia a usuario seguro para ejecutar comandos
USER dbtuser

# Expone el puerto para dagster-webserver si lo usas
# EXPOSE 3000

# Comando por defecto
CMD ["dbt", "--help"]
