from ..scripts.api_connect import api_connect
from ..scripts.cleaned_data_to_data_lake import load_to_data_lake
from ..scripts.load_api_to_data_lake import raw_file_to_data_lake


def connect_to_api(**context):
  json_data = api_connect()
 
  task_instance = context['ti']
  task_instance.xcom_push(key="json_file", value=json_data)


def load_raw_file_to_datalake(**context):

  ti = context['ti']

  json = ti.xcom_pull(task_ids='connect_to_api',key='json_file')
  
  data = raw_file_to_data_lake(json)



def country_info_to_datalake(**context):

  ti = context['ti']

  json = ti.xcom_pull(task_ids='transform_data',key='country_json')
  
  data = load_to_data_lake(json, 'clean', 'country_info.csv')



def language_to_datalake(**context):

  ti = context['ti']

  json = ti.xcom_pull(task_ids='transform_data',key='language_json')
  
  data = load_to_data_lake(json, 'clean', 'language.csv')

