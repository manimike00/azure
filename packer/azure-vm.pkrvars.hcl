# azure-vm.pkrvars.hcl
# Fill in your values and run:
#   packer build -var-file="azure-vm.pkrvars.hcl" .
#
# Never commit real secrets — use env vars (PKR_VAR_*) or a secrets manager in CI/CD.

subscription_id = "15e39dd4-0677-4bcd-bb45-d2deb5edda40"
tenant_id       = "ae154255-ea98-40bb-99ca-a8464d43c627"
client_id       = "1b20ece8-29b9-4b2b-8385-2bac324ee835"
client_secret   = "Us48Q~Bi22UZrjLyMOY8KssqJBllPyqZh23MAaKc"

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
