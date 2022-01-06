

resource "yandex_iam_service_account" "self" {
  folder_id = "${var.folder_id}"
  name      = "${var.sa_name}"
}


resource "yandex_resourcemanager_folder_iam_member" "self" {
  folder_id = "${var.folder_id}"
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
  filename = "${var.sa_key_destination}"
}
