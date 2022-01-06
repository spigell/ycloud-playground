
include "root" {
  path   = find_in_parent_folders()
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

generate "bootstrap_vars" {
  path      = "vars-bootstrap-generated.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "token" {}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  token = var.token
  endpoint = "api.cloud-preprod.yandex.net:443"
  storage_endpoint = "storage.cloud-preprod.yandex.net"
}
EOF
}

terraform {
  source = "../../../tf-modules///ycloud-terraform"
}

inputs = {
  sa_key_destination = format("%s/key.json", get_original_terragrunt_dir())
  folder_id          = get_env("FOLDER_ID", "")
  sa_name            = "${include.root.locals.user}-terraform-helper-${include.env.locals.name}"
  tf_bucket_name     = "${include.root.locals.user}-tf-helper-${include.env.locals.name}"
}
