
resource "azurerm_resource_group" "cderesource" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_data_factory" "cdedatafactory" {
  name                = "cdedatafactory22"
  location            = azurerm_resource_group.cderesource.location
  resource_group_name = azurerm_resource_group.cderesource.name
}

module "storage_account" {
  source = "./storage_account"
  storage_container = "raw"
  location = var.location
  resource_group = "cde_resource"
  storage_account_name = "cdedestorage"

}

module "container_registry" {
  source = "./container_registry"
  location = azurerm_resource_group.cderesource.location
  resource_group_name = azurerm_resource_group.cderesource.name
}

module "data_factory_blob" {
  source = "./data_factory_blob_storage"
  data_factory_id = azurerm_data_factory.cdedatafactory.id
  resource_group_name = azurerm_resource_group.cderesource.name
}

module "data_factory_postgres" {
  source = "./data_factory_postgres"
  data_factory_id = azurerm_data_factory.cdedatafactory.id
}

module "postgresdb" {
  source = "./postgres"
  resource_group_name = azurerm_resource_group.cderesource.name
  location = azurerm_resource_group.cderesource.location

}





