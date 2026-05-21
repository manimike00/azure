terraform {
  required_version = ">=1.9.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.72.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "=3.1.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.8.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "=4.2.1"
    }
  }
}

provider "azurerm" {
  features {}
  #  subscription_id = var.subscription_id
  #  client_id       = var.client_id
  #  client_secret   = var.client_secret
  #  tenant_id       = var.tenant_id
}

#provider "kubernetes" {
#  host                   = module.kubernetes_service.aks-host
#  client_certificate     = module.kubernetes_service.aks-client_certificate
#  client_key             = module.kubernetes_service.aks-client_key
#  cluster_ca_certificate = module.kubernetes_service.aks-cluster_ca_certificate
#}

#provider "helm" {
#  kubernetes {
#    host                   = module.kubernetes_service.aks-host
#    client_certificate     = module.kubernetes_service.aks-client_certificate
#    client_key             = module.kubernetes_service.aks-client_key
#    cluster_ca_certificate = module.kubernetes_service.aks-cluster_ca_certificate
#  }
#  #  kubernetes {
#  #    config_path = "C:\\Users\\ManikandanS\\.kube\\config"
#  #  }
#}
