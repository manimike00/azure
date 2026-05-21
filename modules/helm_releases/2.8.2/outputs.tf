output "deployment" {
  value       = try(helm_release.this[0].metadata, null)
  description = "The state of the helm deployment"
}
