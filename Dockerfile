FROM quay.io/astronomer/astro-runtime:12.4.0


WORKDIR /project

COPY . .

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-postgres && deactivate

ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
USER root