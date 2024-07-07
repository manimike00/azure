variable "algorithm" {}
variable "rsa_bits" {}

resource "tls_private_key" "key_pair" {
  algorithm = var.algorithm
  rsa_bits =  var.rsa_bits
}

output "private_key" {
  value = tls_private_key.key_pair.private_key_pem
}

output "public_key" {
  value = tls_private_key.key_pair.public_key_pem
}

output "public_key_openssh" {
  value = tls_private_key.key_pair.public_key_openssh
}