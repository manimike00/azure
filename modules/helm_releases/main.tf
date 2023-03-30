resource "helm_release" "chart" {
  name       = var.name
  repository = var.repository
  chart      = var.chart
  namespace  = var.namespace
  version    = var.chart_version
  timeout    = 3000

  create_namespace = var.create_namespace

  dynamic "set" {
    for_each = var.values
    iterator = item
    content {
      name  = item.value.name
      value = item.value.value
      type  = item.value.type
    }
  }
}