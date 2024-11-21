
data "azurerm_storage_account" "storageaccountdata" {
  name                = "cdedestorage"
  resource_group_name = azurerm_resource_group.cderesource.name
}

resource "azurerm_resource_group" "cderesource" {
  name     = var.resource_group_name
  location = var.location
}


resource "azurerm_storage_account" "cdestorage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.cderesource.name
  location                 = azurerm_resource_group.cderesource.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "rawstoragecontainer" {
  name                  = var.raw_storage_container
  storage_account_name  = azurerm_storage_account.cdestorage.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cleanstoragecontainer" {
  name                  = "clean"
  storage_account_name  = azurerm_storage_account.cdestorage.name
  container_access_type = "private"
}


resource "azurerm_container_registry" "cdeacr" {
  name                = "cdeContainerRegistry22"
  resource_group_name = azurerm_resource_group.cderesource.name
  location            = azurerm_resource_group.cderesource.location
  sku                 = "Basic"
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

resource "azurerm_data_factory_dataset_delimited_text" "cdebloblangds" {
  name                = "cde_blob_lang_ds"
  data_factory_id     = azurerm_data_factory.cdedatafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.cdeblobstoragels.name

  encoding            = "UTF-8"
  quote_character     = "x"
  escape_character    = "f"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "clean"
    filename = "language.csv"
  }
}

resource "azurerm_data_factory_dataset_delimited_text" "cdeblobcountriesds" {
  name                = "cde_blob_countries_ds"
  data_factory_id     = azurerm_data_factory.cdedatafactory.id
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.cdeblobstoragels.name

  encoding            = "UTF-8"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "clean"
    filename = "country_info.csv"
  }
}