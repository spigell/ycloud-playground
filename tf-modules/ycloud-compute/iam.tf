
resource "random_pet" "compute_master" {}

resource "random_pet" "compute_worker" {}

resource "yandex_iam_service_account" "compute_master" {
  name = random_pet.compute_master.id
}

resource "yandex_iam_service_account" "compute_worker" {
  name = random_pet.compute_worker.id
}

resource "yandex_resourcemanager_folder_iam_member" "compute_admin" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.compute_master.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "lb_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.compute_master.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "alb_admin" {
  folder_id = var.folder_id
  role      = "alb.admin"
  member    = "serviceAccount:${yandex_iam_service_account.compute_master.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_admin" {
  folder_id = var.folder_id
  role      = "vpc.admin"
  member    = "serviceAccount:${yandex_iam_service_account.compute_master.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "master_with_iam_user" {
  folder_id = var.folder_id
  role      = "iam.serviceAccounts.user"
  member    = "serviceAccount:${yandex_iam_service_account.compute_master.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "worker_with_compute_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.compute_worker.id}"
}
