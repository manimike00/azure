#variable "secret_name" {}
#variable "secret_value" {}
variable "key_vault_id" {}

variable "secret_maps" {
  type = map(string)
  default = {
    "name1" = "value1"
    "aaa"   = "111"
    "bbb"   = "222"
  }
}