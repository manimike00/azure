terraform {
  required_version = ">=1.9.1"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.72.0"
    }
  }
}

provider "azurerm" {
  features {}
}
