
locals {
  user = "schukh"
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.71.0"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
EOF
}

generate "vars" {
  path      = "vars-computed.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable folder_id {}

variable "network_id" {
  default = null
}

variable "subnets" {
  type = map(any)
  default = {}
}
EOF
}
