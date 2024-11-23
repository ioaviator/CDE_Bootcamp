
// postgresql server

resource "azurerm_postgresql_flexible_server" "cdepgserver" {
  name                          = "cdepgserver22"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12"
  public_network_access_enabled = true
  administrator_login           = var.db_admin_login
  administrator_password        = var.db_admin_pass
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P30"

  sku_name    = "GP_Standard_D4s_v3"
  create_mode = "Default"

  authentication {
    password_auth_enabled = true
  }

}

resource "azurerm_postgresql_flexible_server_database" "cdepgdb" {
  name      = "cdepgdb22"
  server_id = azurerm_postgresql_flexible_server.cdepgserver.id
  collation = "en_US.utf8"
  charset   = "utf8"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}
