import os

from azure.storage.blob import BlobServiceClient
from dotenv import load_dotenv

load_dotenv()

account_name='cdedestorage'
account_url=f"https://{account_name}.blob.core.windows.net"

blob_url = os.getenv("BLOB_URL")
account_key = os.getenv("ACCOUNT_KEY")

  # Create a BlobServiceClient object
blob_service_client = BlobServiceClient(account_url=account_url, credential=account_key)