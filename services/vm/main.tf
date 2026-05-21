# VM module to provision a Linux VM in a subnet.

module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource-group
  location = var.location
  env      = var.env
  project  = var.project
}


module "vnet" {
  source              = "../../modules/virtual_network"
  name = "demo-vnet"
  resource_group_name = module.resource_group.resource-grp
  location            = var.location
  env                 = var.env
  project             = var.project
  address_space       = "10.11.0.0/16"
}

module "subnets" {
  source                = "../../modules/subnets"
  name                  = "demo-subnet"
  resource_group_name   = module.resource_group.resource-grp
  virtual_network_name  = module.vnet.vnet
  address_prefixes      = "10.11.1.0/24"
}

module "bastion_public_ip" {
  source              = "../../modules/public_ip"
  name                = "demo-vm-ip"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.resource_group.resource-grp
  allocation_method   = "Static"
}

locals {
  ngrules = {
    ssh = {
      name                       = "ssh"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

module "bastion_network_sg" {
  source              = "../../modules/network_security_group"
  name                = "demo-vm-sg"
  env                 = var.env
  location            = var.location
  project             = var.project
  resource_group_name = module.resource_group.resource-grp
}

module "network_sg_rules" {
  source                      = "../../modules/network_security_group_rule"
  for_each                    = local.ngrules
  name                        = each.key
  resource_group_name         = module.resource_group.resource-grp
  direction                   = each.value.direction
  access                      = each.value.access
  priority                    = each.value.priority
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  network_security_group_name = module.bastion_network_sg.network_sg
}

module "nic" {
  source               = "../../modules/network_interface"
  name                 = "demo-vm-nic" 
  env                  = var.env
  location             = var.location
  project              = var.project
  public_ip_address_id = module.bastion_public_ip.public-id
  resource_group_name  = module.resource_group.resource-grp
  subnet_id            = module.subnets.subnets-id
}

module "bastion_nic_sg_bind" {
  source                    = "../../modules/nic_sg_association"
  network_interface_id      = module.nic.nic_id
  network_security_group_id = module.bastion_network_sg.network_sg_id
}

module "vm" {
  source                = "../../modules/virtual_machine"
  name                  = "demo-vm"
  admin_username        = "azureuser"
  env                   = var.env
  location              = var.location
  project               = var.project
  network_interface_ids = [module.nic.nic_id]
  size                  = "Standard_NC4as_T4_v3"
  identity              = "SystemAssigned"
  resource_group_name   = module.resource_group.resource-grp
  custom_data           = file("${path.module}/customdata/data.sh")
  public_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDCswWDg3DBQFLlYeD2An715HbJOuITMJ4UdnhUvntrpaFAB3uOYsisfJ8xbFMxOeGip8+Ekl4GNmAgpXp5Qtpvx3KcP+d3j+kEqQLvIWrR8aNK/CG/qGlZ5pN68qiBpc1pXkxeBnOZaEFcFHvg7gyhzLGm+ZvkBpjvQptX2e48eyC0n7FZhuPjgQ8NiL5nYgy8VQSKjAwMUirQpZ8ZcifR2lWT4OmL+d8jvpSLu1e1Xtx23zxCtw13VegQJob+U4w2Aw+gX49yGpigc2+EC+pSjZjdWmFd1AaBwOCJUuBRhkyhz5VptqU6AYuocjgTA4phk+VCGp7LKdTbl4AYnpzdOcIu6g+RKd4ThVeZW6/YOB5wmdEIMXJwcEOHH4l7rj9mILds5ek+OyONS+tMKO9372srA6BN+6h8obSAGZ0O1UIdp1NF+aJZ4uFrquI5FSZ9/ZiDTMYxXNFAmUwMqyvCRccs4iTVzxGw7ItROCW/Nf+z3ggtx+btE6dmSgTgoL56hukSZH8voPw7SCXP4CU2o9MKd1mS9VcpBScFhUEWnCMBgUmifO52Z1C8GklKbFgxO5CS5+EZXgOPmsBx2Xw8+2tDk89MPOfuDRrtTf7LuLXDN7af5JNxfjiR/9flHn5UTX5HZ0nkkKsvxoIdGWk0hHLYP5H/D1q68iDeYgreeQ== mani@technophile"
}