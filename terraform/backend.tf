
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }

   backend "azurerm" {
    resource_group_name  = "tf-backend"
    storage_account_name = "cdetfstatebackend"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
