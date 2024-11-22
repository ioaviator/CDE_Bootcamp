
resource "azurerm_container_registry" "cdeacr" {
  name                = "cdeContainerRegistry22"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
}

