
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  # subscription_id = file("credentials.txt")
}

resource "azurerm_resource_group" "cderesource" {
  name     = var.resource_group_name
  location = "South Africa North"
}

resource "azurerm_storage_account" "cdestorage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.cderesource.name
  location                 = azurerm_resource_group.cderesource.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

}

resource "azurerm_storage_container" "rawstoragecontainer" {
  name                  = var.raw_storagecontainer
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


// postgresql server

resource "azurerm_virtual_network" "cdevnet" {
  name                = "cde-vnet"
  location            = azurerm_resource_group.cderesource.location
  resource_group_name = azurerm_resource_group.cderesource.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "cdesubnet" {
  name                 = "cde-snet"
  resource_group_name  = azurerm_resource_group.cderesource.name
  virtual_network_name = azurerm_virtual_network.cdevnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_private_dns_zone" "cdepdns" {
  name                = "cdepgsererver.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.cderesource.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink" {
  name                  = "cdeVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.cdepdns.name
  virtual_network_id    = azurerm_virtual_network.cdevnet.id
  resource_group_name   = azurerm_resource_group.cderesource.name
  depends_on            = [azurerm_subnet.cdesubnet]
}

resource "azurerm_postgresql_flexible_server" "example" {
  name                          = "cdepgserver"
  resource_group_name           = azurerm_resource_group.cderesource.name
  location                      = azurerm_resource_group.cderesource.location
  version                       = "12"
  delegated_subnet_id           = azurerm_subnet.cdesubnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.cdepdns.id
  public_network_access_enabled = false
  administrator_login           = "adminadmin"
  administrator_password        = "12345678He/"
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name   = "GP_Standard_D4s_v3"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnetlink]

}