# general
variable "name" {
  default = "core"
}
variable "env" {
  default = "demo"
}
variable "project" {
  default = "poc"
}
variable "location" {
  default = "centralindia"
}

variable "address_space" {
  default = "10.100.0.0/16"
}

variable "address_prefixes_default_np" {
  default = "10.100.0.0/20"
}

variable "address_prefixes_monitoring_np" {
  default = "10.100.50.0/24"
}

variable "address_prefixes_public_subnet" {
  default = "10.100.49.0/24"
}

variable "kubernetes_version" {
  default = "1.35.3"
}

variable "subscription_id" {
  sensitive = true
}

variable "tenant_id" {
  sensitive = true
}

variable "client_id" {
  sensitive = true
}

variable "client_secret" {
  sensitive = true
}
