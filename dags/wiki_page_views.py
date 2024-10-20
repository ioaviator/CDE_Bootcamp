from airflow import DAG
from datetime import datetime
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import requests
import gzip
from sqlalchemy import create_engine


BASE_URL="https://dumps.wikimedia.org/other/pageviews/2024/2024-10/"
FILE="pageviews-20241014-050000.gz"


def download_file(url, location):
  response = requests.get(url)
  with open(location, 'wb') as f:
    f.write(response.content)
  return location

def process(filepath):
  cmds = []
  companies = ["Amazon", "Apple", "Facebook", "Google", "Microsoft"]
  with open(filepath, 'rb') as f:
    for line in f:
      for company in companies:
        if(company in line.decode('utf-8') ):
          views = line.decode().strip().split(" ")[-2]
          cmds.append(f"INSERT INTO pageviews (company, views) VALUES ('{company}', {views});")
  return cmds

db_uri = 'sqlite:///airflow.db'
engine = create_engine(db_uri)

def create_table():
    # SQL statement to create the pageviews table
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS pageviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        company TEXT NOT NULL,
        views INTEGER NOT NULL
    );
    """
    with engine.connect() as connection:
      connection.execute(create_table_sql)



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

  extract = BashOperator(
    task_id='extract_views',
    bash_command='gzip -dv {{ task_instance.xcom_pull(task_ids="download_views") }}'
  )

  process = PythonOperator(
    task_id='process_views',
    python_callable=process,
    op_kwargs={'filepath': '/tmp/' + FILE.replace('.gz', '')},
    do_xcom_push=True
  )
create_table = PythonOperator(
  task_id='create_table',
  python_callable=create_table,
)



download >> extract >> process >> create_table