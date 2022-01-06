
output "s3_secret_key" {
  value     = yandex_iam_service_account_static_access_key.self.secret_key
  sensitive = true
}

output "s3_access_key" {
  value     = yandex_iam_service_account_static_access_key.self.access_key
  sensitive = true
}
