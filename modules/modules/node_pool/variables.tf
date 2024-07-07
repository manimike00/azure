variable "name" {}
variable "project" {}
variable "location" {}
variable "env" {}
variable "kubernetes_cluster_id" {}
variable "vm_size" {}
variable "node_count" {}
variable "max_count" {}
variable "min_count" {}
variable "environment" {}
variable "vnet_subnet_id" {}

variable "use_spot" {
  type = bool
}

variable "spot_max_price" {
  type    = number
  default = -1
}