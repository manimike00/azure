# azure-vm.pkrvars.hcl
# Fill in your values and run:
#   packer build -var-file="azure-vm.pkrvars.hcl" .
#
# Never commit real secrets — use env vars (PKR_VAR_*) or a secrets manager in CI/CD.

subscription_id = ""
tenant_id       = ""
client_id       = ""
client_secret   = ""

location                     = "centralindia"
managed_image_name           = "ubuntu-22-04-base"
managed_image_resource_group = "rg-packer-images"
vm_size                      = "Standard_D2s_v3"
os_disk_size_gb              = 30

tags = {
  Environment = "shared"
  ManagedBy   = "packer"
  OS          = "ubuntu-22-04"
}
