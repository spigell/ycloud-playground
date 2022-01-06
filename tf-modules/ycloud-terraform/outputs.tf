
output "folder_id" {
  value = "${var.folder_id}"
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.self.secret_key
  sensitive = true
}

output "access_key" {
  value     = yandex_iam_service_account_static_access_key.self.access_key
  sensitive = true
}

output "tf_bucket" {
  value     = "${yandex_storage_bucket.tf-backend-encripted.bucket}"
}

output "sa_key_path" {
  value = local_file.creds.filename
}
