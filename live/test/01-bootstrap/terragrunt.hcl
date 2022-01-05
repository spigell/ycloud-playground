
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  %{if get_env("BACKEND_LOCAL", false)}
  backend "local" {}
  %{else}
  backend "remote" {
    organization = "spigell_private"
    workspaces {
      name = "yCloud-learning"
    }
  }
  %{endif}
}
EOF
}

generate "bootstrap-vars" {
  path      = "vars-computed.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "cloud_id" {
  default = "b1gto2kt4b27oop3c9kd"
}
variable "token" {}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  token = var.token
  cloud_id = var.cloud_id
}
EOF
}

terraform {
  source = "../../../tf-modules///configure-tf"
}

inputs = {}
