variable "name" {}
variable "repository" {}
variable "chart" {}
variable "namespace" {}
variable "chart_version" {}
variable "create_namespace" {
  type = bool
}
variable "values" {
  description = "list of values to assign to key values"
  type = list(object({
    name  = string
    value = string
    type  = string
  }))
  #  default = [
  #    { name = "service.type", value = "ClusterIP", type = "string" }
  #  ]
}