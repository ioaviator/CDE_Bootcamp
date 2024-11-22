
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

  column_delimiter    = ","
  row_delimiter       = "NEW"
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

  column_delimiter    = ","
  row_delimiter       = "NEW"
  encoding            = "UTF-8"
  first_row_as_header = true
  null_value          = "NULL"

  azure_blob_storage_location {
    container = "clean"
    filename = "country_info.csv"
  }
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
  name                = "cdepgsererver22.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.cderesource.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink" {
  name                  = "cdeVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.cdepdns.name
  virtual_network_id    = azurerm_virtual_network.cdevnet.id
  resource_group_name   = azurerm_resource_group.cderesource.name
  depends_on            = [azurerm_subnet.cdesubnet]
}

resource "azurerm_postgresql_flexible_server" "cdepgserver" {
  name                          = "cdepgserver22"
  resource_group_name           = azurerm_resource_group.cderesource.name
  location                      = azurerm_resource_group.cderesource.location
  version                       = "12"
  delegated_subnet_id           = azurerm_subnet.cdesubnet.id
  private_dns_zone_id           = azurerm_private_dns_zone.cdepdns.id
  public_network_access_enabled = false
  administrator_login           = "adminadmin"
  administrator_password        = ""
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name   = "GP_Standard_D4s_v3"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.vnetlink]

}

resource "azurerm_postgresql_flexible_server_database" "example" {
  name      = "exampledb"
  server_id = azurerm_postgresql_flexible_server.example.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}