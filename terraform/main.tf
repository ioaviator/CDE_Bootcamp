
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
