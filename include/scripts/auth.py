import os

from azure.storage.blob import BlobServiceClient, ContainerClient
from dotenv import load_dotenv

load_dotenv()

account_name='cdedestorage'
account_url=f"https://{account_name}.blob.core.windows.net"

account_key = os.getenv("ACCOUNT_KEY")

  # Create a BlobServiceClient object
blob_service_client = BlobServiceClient(account_url=account_url, credential=account_key)

################################

conn_string = os.getenv("CONN_STRING")
blob_name = 'countries_api.parquet'

container = ContainerClient.from_connection_string(conn_str=conn_string, container_name='raw')

blob_client = container.get_blob_client(blob=blob_name)

