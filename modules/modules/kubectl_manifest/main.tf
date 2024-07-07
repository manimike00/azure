variable "yaml_body" {}

resource "kubectl_manifest" "manifest" {
  yaml_body = var.yaml_body
}

output "kind" {
  value = kubectl_manifest.manifest.kind
}