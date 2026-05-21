# VNet Service

This service composes the existing modules to create:

- Resource group
- Virtual network
- Configurable subnets
- Optional NAT gateway with public IP
- Optional private DNS zones linked to the VNet

## Usage

```sh
terraform init
terraform plan
terraform apply
```

Update `terraform.tfvars` to change CIDRs, subnet names, NAT gateway attachment, or private DNS zones.
