output "resource_group_name" {
  value = module.resource_group.resource-grp
}

output "resource_group_id" {
  value = module.resource_group.resource-id
}

output "vnet_name" {
  value = module.virtual_network.vnet
}

output "vnet_id" {
  value = module.virtual_network.vnet-id
}

output "subnet_names" {
  value = {
    for key, subnet in module.subnets : key => subnet.subnets
  }
}

output "subnet_ids" {
  value = {
    for key, subnet in module.subnets : key => subnet.subnets-id
  }
}

output "nat_gateway_id" {
  value = var.enable_nat_gateway ? module.nat_gateway[0].nat_gw_id : null
}

output "private_dns_zone_ids" {
  value = {
    for key, zone in module.private_dns_zones : key => zone.private_dns_zone_id
  }
}
