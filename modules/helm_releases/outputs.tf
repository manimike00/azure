output "helm_release_name" {
  value = helm_release.chart.name
}

output "helm_release_id" {
  value = helm_release.chart.id
}