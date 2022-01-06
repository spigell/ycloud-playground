locals {
  zone = "ru-central1-b"
}

resource "yandex_kubernetes_cluster" "personal_1" {
  name        = "personal-k8s-testing-1"
  description = "Personal simple kube cluster"

  network_id = var.network_id

  cluster_ipv4_range = var.k8s_cluster_ipv4_range
  service_ipv4_range = var.k8s_service_ipv4_range

  master {
    zonal {
      zone      = local.zone
      subnet_id = var.subnets[local.zone].id
    }

    version = var.k8s_version

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.k8s.id
  node_service_account_id = yandex_iam_service_account.k8s_nodes.id

  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

}

resource "yandex_kubernetes_node_group" "personal_1_1" {
  cluster_id  = yandex_kubernetes_cluster.personal_1.id
  description = "description"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [var.subnets[local.zone].id]
    }

    resources {
      memory = 4
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = var.k8s_container_runtime_type
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = local.zone
    }
    //    location {
    //      zone = "ru-central1-a"
    //    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}

resource "yandex_kubernetes_node_group" "personal_1_2" {
  cluster_id  = yandex_kubernetes_cluster.personal_1.id
  description = "description"
  version     = var.k8s_version

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [var.subnets[local.zone].id]
    }

    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 32
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = var.k8s_container_runtime_type
    }
  }

  scale_policy {
    auto_scale {
      min     = 1
      max     = 5
      initial = 1
    }
  }

  allocation_policy {
    location {
      zone = local.zone
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      day        = "monday"
      start_time = "15:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "friday"
      start_time = "10:00"
      duration   = "4h30m"
    }
  }
}
