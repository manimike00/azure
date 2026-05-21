# =============================================================================
# Azure VM Image - Packer Template (HCL2)
# OS      : Ubuntu 22.04 LTS
# Auth    : Service Principal (client_id + client_secret)
# Output  : Managed Image
# =============================================================================
# Usage:
#   packer init .
#   packer validate -var-file="azure-vm.pkrvars.hcl" .
#   packer build    -var-file="azure-vm.pkrvars.hcl" .
# =============================================================================

packer {
  required_version = ">= 1.9.0"

  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}

# ---------------------------------------------------------------------------
# Variables
# ---------------------------------------------------------------------------

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "client_id" {
  type        = string
  description = "Service Principal Client ID"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Service Principal Client Secret"
  sensitive   = true
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Azure region for the build and managed image"
  default     = "eastus"
}

variable "managed_image_name" {
  type        = string
  description = "Name of the resulting managed image"
  default     = "ubuntu-22-04-base"
}

variable "managed_image_resource_group" {
  type        = string
  description = "Resource group to store the managed image in (must already exist)"
  default     = "rg-packer-images"
}

variable "vm_size" {
  type        = string
  description = "Azure VM size used during the image build"
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  type        = number
  description = "OS disk size in GB"
  default     = 30
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the managed image"
  default = {
    Environment = "shared"
    ManagedBy   = "packer"
    OS          = "ubuntu-22-04"
  }
}

# ---------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------

locals {
  timestamp          = formatdate("YYYYMMDD-hhmmss", timestamp())
  managed_image_name = "${var.managed_image_name}-${local.timestamp}"
}

# ---------------------------------------------------------------------------
# Source
# ---------------------------------------------------------------------------

source "azure-arm" "ubuntu_2204" {
  # Authentication
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id

  # Marketplace base image
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"
  image_version   = "latest"

  # Build VM settings
  location        = var.location
  vm_size         = var.vm_size
  os_type         = "Linux"
  os_disk_size_gb = var.os_disk_size_gb

  # Managed image output
  managed_image_name                = local.managed_image_name
  managed_image_resource_group_name = var.managed_image_resource_group

  # SSH communicator (Packer injects a temporary key automatically)
  communicator = "ssh"
  ssh_username = "packer"

  # Tags on the image
  azure_tags = var.tags
}

# ---------------------------------------------------------------------------
# Build
# ---------------------------------------------------------------------------

build {
  name    = "azure-ubuntu-2204-managed-image"
  sources = ["source.azure-arm.ubuntu_2204"]

  # 1. Wait for cloud-init + system update
  provisioner "shell" {
    inline = [
      "echo '>>> Waiting for cloud-init...'",
      "sudo cloud-init status --wait || true",
      "echo '>>> Updating system packages...'",
      "sudo apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean",
    ]
  }

  # 2. Install common utilities
  provisioner "shell" {
    inline = [
      "echo '>>> Installing common utilities...'",
      "sudo apt-get install -y curl wget git unzip zip jq ca-certificates gnupg lsb-release htop net-tools dnsutils",
    ]
  }

  # 3. (Optional) Upload and run your own script
  # provisioner "file" {
  #   source      = "scripts/harden.sh"
  #   destination = "/tmp/harden.sh"
  # }
  # provisioner "shell" {
  #   inline = ["sudo bash /tmp/harden.sh"]
  # }

  # 4. Deprovision & generalize — MUST be the final step
  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "echo '>>> Deprovisioning...'",
      "sudo waagent -force -deprovision+user",
      "export HISTSIZE=0",
      "sync",
    ]
  }

  # Output a manifest file after successful build
  post-processor "manifest" {
    output     = "packer-manifest.json"
    strip_path = true
  }
}
