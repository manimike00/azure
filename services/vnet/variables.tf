variable "name_prefix" {
  default = "demo-rapyder"
}

variable "project" {
  default = "rapyder"
}

variable "env" {
  default = "dev"
}

variable "location" {
  default = "centralindia"
}

variable "resource_group_name" {
  default = "demo-rapyder-vnet-rg"
}

variable "vnet_name" {
  default = "demo-rapyder-vnet"
}

variable "address_space" {
  default = "10.11.0.0/16"
}

variable "subnets" {
  type = map(object({
    name              = string
    address_prefix    = string
    service_endpoints = optional(list(string), null)
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = list(string)
    }), null)
  }))

  default = {
    default = {
      name           = "demo-rapyder-system-subnet"
      address_prefix = "10.11.0.0/22"
    }
    public = {
      name           = "demo-rapyder-public-subnet"
      address_prefix = "10.11.4.0/22"
    }
    private = {
      name           = "demo-rapyder-private-subnet"
      address_prefix = "10.11.8.0/22"
    }
  }
}

variable "enable_nat_gateway" {
  default = true
}

variable "nat_gateway_subnet_keys" {
  type    = list(string)
  default = ["public", "private"]
}

variable "private_dns_zones" {
  type = map(object({
    name     = string
    dns_name = string
  }))

  default = {}
}
