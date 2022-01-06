
resource "random_pet" "db_viewer" {}

resource "yandex_iam_service_account" "db_viewer" {
  description = "SA for YDB personal testing"
  name        = random_pet.db_viewer.id
}

resource "yandex_resourcemanager_folder_iam_member" "ydb_viewer" {
  folder_id = var.folder_id
  role      = "ydb.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.db_viewer.id}"
}
