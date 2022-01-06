
resource "random_pet" "agent" {}

resource "yandex_iam_service_account" "agent" {
  description = "SA for Data proc agent"
  name        = random_pet.agent.id
}

resource "yandex_resourcemanager_folder_iam_member" "agent" {
  folder_id = var.folder_id
  role      = "mdb.dataproc.agent"
  member    = "serviceAccount:${yandex_iam_service_account.agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "agent_with_compute_admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "agent_with_vpc_user" {
  folder_id = var.folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "agent_with_dns_editor" {
  folder_id = var.folder_id
  role      = "dns.editor"
  member    = "serviceAccount:${yandex_iam_service_account.agent.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "agent_with_iam_user" {
  folder_id = var.folder_id
  role      = "iam.serviceAccounts.user"
  member    = "serviceAccount:${yandex_iam_service_account.agent.id}"
}
