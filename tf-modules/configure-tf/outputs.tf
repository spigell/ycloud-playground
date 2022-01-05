output "folder_id" {
  value = yandex_resourcemanager_folder.self.id
}

output "cloud_id" {
  value = var.cloud_id
}

output "secret_key" {
  value = yandex_iam_service_account_static_access_key.self.secret_key
  sensitive = true
}

output "access_key" {
  value = yandex_iam_service_account_static_access_key.self.access_key
  sensitive = true
}