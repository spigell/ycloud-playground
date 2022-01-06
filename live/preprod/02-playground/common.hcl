generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  service_account_key_file = "${dependency.bootstrap.outputs.sa_key_path}"
  endpoint = "api.cloud-preprod.yandex.net:443"
  storage_endpoint = "storage.cloud-preprod.yandex.net"
  folder_id                = "${dependency.bootstrap.outputs.folder_id}"
  zone                     = "ru-central1-a"
}
EOF
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  %{if get_env("BACKEND_LOCAL", false)}
  backend "local" {}
  %{else}
  backend "s3" {
    # encrypt = true
    # Default encryption enabled in bucket
    bucket                      = "${dependency.bootstrap.outputs.tf_bucket}"
    key                         = "${path_relative_to_include()}/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "storage.cloud-preprod.yandex.net"
    secret_key                  = "${dependency.bootstrap.outputs.secret_key}"
    access_key                  = "${dependency.bootstrap.outputs.access_key}"
    skip_region_validation      = true
    skip_credentials_validation = true
  }
  %{endif}
}
EOF
}

dependency "bootstrap" {
  config_path = "../../01-bootstrap"
}

inputs = {
  folder_id = "${dependency.bootstrap.outputs.folder_id}"
}
