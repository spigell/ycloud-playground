
variable "network_id" {}

variable "subnets" {
  type = map(any)
}

variable "admin_password" {
  sensitive = true
}
