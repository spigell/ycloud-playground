
resource "yandex_iam_service_account_static_access_key" "self" {
  service_account_id = yandex_iam_service_account.self.id
  description        = "static access key for object storage"
}

resource "yandex_kms_symmetric_key" "tf-key" {
  folder_id         = var.folder_id
  name              = "tf-key"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" // equal to 1 year
}

resource "yandex_storage_bucket" "tf-backend-encripted" {
  force_destroy = false
  access_key    = yandex_iam_service_account_static_access_key.self.access_key
  secret_key    = yandex_iam_service_account_static_access_key.self.secret_key
  bucket        = var.tf_bucket_name
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.tf-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
