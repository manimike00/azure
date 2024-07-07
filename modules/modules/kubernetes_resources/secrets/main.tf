resource "kubernetes_secret" "ks" {
  metadata {
    name = var.name
  }
  data = var.data
  type = var.type
}
