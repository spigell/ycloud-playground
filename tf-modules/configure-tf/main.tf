terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_resourcemanager_folder" "self" {
  name = "learn"
}

resource "yandex_iam_service_account" "self" {
  folder_id = yandex_resourcemanager_folder.self.id
  name      = "terraform-helper"
}


resource "yandex_resourcemanager_folder_iam_member" "self" {
  folder_id = yandex_resourcemanager_folder.self.id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.self.id}"
}

resource "yandex_iam_service_account_key" "self" {
  service_account_id = yandex_iam_service_account.self.id
  description        = "key for service account"
  key_algorithm      = "RSA_4096"
}

resource "local_file" "creds" {
  content = jsonencode({
    "id"                 = yandex_iam_service_account_key.self.id,
    "service_account_id" = yandex_iam_service_account_key.self.service_account_id,
    "private_key"        = yandex_iam_service_account_key.self.private_key,
  "public_key" = yandex_iam_service_account_key.self.public_key })
  filename = "/tmp/key.json"
}

resource "yandex_iam_service_account_static_access_key" "self" {
  service_account_id = yandex_iam_service_account.self.id
  description        = "static access key for object storage"
}

resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.self.access_key
  secret_key = yandex_iam_service_account_static_access_key.self.secret_key
  bucket = "tf-bucket-examples-vm"
}