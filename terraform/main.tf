
resource "azurerm_resource_group" "cderesource" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_storage_account" "storageaccountdata" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  depends_on = [ azurerm_storage_account.cdestorage ] 
}


resource "azurerm_storage_account" "cdestorage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}


resource "azurerm_storage_container" "rawstoragecontainer" {
  name                  = "raw"
  storage_account_name  = "cdedestorage"
  container_access_type = "private"
}

resource "azurerm_storage_container" "cleanstoragecontainer" {
  name                  = "clean"
  storage_account_name  = "cdedestorage"
  container_access_type = "private"
}

resource "azurerm_data_factory" "cdedatafactory" {
  name                = "cdedatafactory22"
  location            = azurerm_resource_group.cderesource.location
  resource_group_name = azurerm_resource_group.cderesource.name
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "cdeblobstoragels" {
  name              = "cde_blob_ls"
  data_factory_id   = azurerm_data_factory.cdedatafactory.id
  connection_string = data.azurerm_storage_account.storageaccountdata.primary_connection_string
}

module "data_factory_blob_storage" {
  source = "./data_factory_blob_storage"
  data_factory_id = azurerm_data_factory.cdedatafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.cdeblobstoragels.name
}

module "data_factory_postgres" {
  source = "./data_factory_postgres"
  data_factory_id = azurerm_data_factory.cdedatafactory.id
}


module "container_registry" {
  source = "./container_registry"
  location = azurerm_resource_group.cderesource.location
  resource_group_name = azurerm_resource_group.cderesource.name
}

module "postgresdb" {
  source = "./postgresdb"
  resource_group_name = azurerm_resource_group.cderesource.name
  location = azurerm_resource_group.cderesource.location

}