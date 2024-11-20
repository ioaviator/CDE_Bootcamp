from .scripts.load_api_to_data_lake import load_to_data_lake


def load_to_datalake(**context):

  ti = context['ti']

  json = ti.xcom_pull(task_ids='connect_to_api',key='json_file')
  
  data = load_to_data_lake(json)
