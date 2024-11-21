import pandas as pd

from .auth import blob_service_client


def load_to_data_lake(data):

  data_df = pd.DataFrame(data)

  # Define your Azure Blob Storage account details
  container_name = 'raw'
  blob_name = 'countries_api.parquet'

  # Convert your pandas dataframe to a CSV string
  parquet = data_df.to_parquet(index=False)

  # Upload the bytes object to Azure Blob Storage
  blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
  blob_client.upload_blob(parquet, overwrite=True)
  print('upload to storage account successful')

