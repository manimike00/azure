terraform {
  required_version = ">=1.4.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "kubernetes" {
  host                   = module.kubernetes_service.aks-host
  client_certificate     = module.kubernetes_service.aks-client_certificate
  client_key             = module.kubernetes_service.aks-client_key
  cluster_ca_certificate = module.kubernetes_service.aks-cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.kubernetes_service.aks-host
    client_certificate     = module.kubernetes_service.aks-client_certificate
    client_key             = module.kubernetes_service.aks-client_key
    cluster_ca_certificate = module.kubernetes_service.aks-cluster_ca_certificate
  }
}
