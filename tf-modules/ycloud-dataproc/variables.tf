
variable "s3_secret_key" {
  sensitive = true
}

variable "s3_access_key" {
  sensitive = true
}

variable "ssh_key" {}


variable "dataproc_with_personal" {
  default = false
}
