
resource "yandex_iam_service_account" "k8s" {
  name = "k8s-${var.k8s_name}"
}

resource "yandex_iam_service_account" "k8s_nodes" {
  name = "k8s-${var.k8s_name}-nodes"
}

resource "yandex_resourcemanager_folder_iam_member" "k8s_cluster_agent" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc_publicAdmin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "lb_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cr_images_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}
