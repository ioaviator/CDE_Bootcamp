from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import requests
import gzip
import os

BASE_URL="https://dumps.wikimedia.org/other/pageviews/2024/2024-10/"
FILE="pageviews-20241014-050000.gz"


def download_file(url, location):
  response = requests.get(url)
  with open(location, 'wb') as f:
    f.write(response.content)
  return location


with DAG(
  dag_id='wiki_page_views',
  start_date=datetime(2024,10,18),
  schedule_interval="@hourly",
  catchup=False
) as dag:

  download = PythonOperator(
    task_id='download_views',
    python_callable=download_file,
    op_kwargs={'url': f"{BASE_URL}{FILE}", 'location': f"/tmp/{FILE}"},
    do_xcom_push=True

  )


download