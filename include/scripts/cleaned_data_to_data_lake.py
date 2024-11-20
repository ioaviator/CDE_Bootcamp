import pandas as pd

from .auth import blob_service_client


def load_to_data_lake(data, container, blob_name):

  data_df = pd.DataFrame(data)

  # Define your Azure Blob Storage account details
  container_ = container
  blob_ = blob_name

  # Convert your pandas dataframe to a CSV string
  data = data_df.to_csv(index=False)

  # Upload the bytes object to Azure Blob Storage
  blob_client = blob_service_client.get_blob_client(container=container_, blob=blob_)
  blob_client.upload_blob(data, overwrite=True)
  print('upload to storage account successful')

