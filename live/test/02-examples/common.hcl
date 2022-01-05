generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "yandex" {
  service_account_key_file = "/tmp/key.json"
  cloud_id                 = "${dependency.bootstrap.outputs.cloud_id}"
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
    bucket         = "tf-bucket-examples"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region     = "us-east-1"
    endpoint   = "storage.yandexcloud.net"
    secret_key = "${dependency.bootstrap.outputs.secret_key}"
    access_key = "${dependency.bootstrap.outputs.access_key}"
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

generate "vars" {
  path      = "vars-computed.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable folder_id {}
EOF
}

inputs = {
  folder_id = "${dependency.bootstrap.outputs.folder_id}"
}
