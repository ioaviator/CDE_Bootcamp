
resource "azurerm_data_factory_linked_service_postgresql" "cdepgls" {
  name              = "cde_pg_ls"
  data_factory_id   = var.data_factory_id
  connection_string = "Host=cdepgserver22;Port=5432;Database=cdepgdb22;UID=${var.db_admin_login};EncryptionMethod=1;Password=${var.db_admin_pass}"
}

resource "azurerm_data_factory_dataset_postgresql" "cdepgds" {
  name                = "cde_pg_ds"
  data_factory_id     = var.data_factory_id
  linked_service_name = azurerm_data_factory_linked_service_postgresql.cdepgls.name
}