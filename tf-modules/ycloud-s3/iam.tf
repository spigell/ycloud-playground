
resource "random_pet" "owner" {}

resource "random_pet" "without_binding" {}

resource "random_pet" "with_binding" {}

resource "yandex_iam_service_account" "owner" {
  name = random_pet.owner.id
}

resource "yandex_resourcemanager_folder_iam_member" "self_storage_admin" {
  folder_id = var.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.owner.id}"
}

resource "yandex_iam_service_account_static_access_key" "self" {
  service_account_id = yandex_iam_service_account.owner.id
  description        = "static access key for s3 buckets"
}

resource "yandex_iam_service_account" "uploader_without_binding" {
  name        = random_pet.without_binding.id
  description = "SA without bindings for testing grants and policies (S3)"
}

resource "yandex_iam_service_account" "uploader_with_binding" {
  name        = random_pet.with_binding.id
  description = "SA with bindings for testing grants and policies (S3)"
}

resource "yandex_resourcemanager_folder_iam_member" "storage_uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"
  member    = "serviceAccount:${yandex_iam_service_account.uploader_with_binding.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage_uploader" {
  service_account_id = yandex_iam_service_account.uploader_with_binding.id
  description        = "static access key for s3 buckets"
}
