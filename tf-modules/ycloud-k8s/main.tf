terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_iam_service_account" "k8s" {
  name        = "k8s-${var.k8s_name}"
}

resource "yandex_iam_service_account" "k8s_nodes" {
  name        = "k8s-${var.k8s_name}-nodes"
}

resource "yandex_vpc_network" "self" {
  name = "${var.k8s_name}"
}

resource "yandex_vpc_subnet" "self" {
  v4_cidr_blocks = ["10.1.0.0/16"]
  network_id     = "${yandex_vpc_network.self.id}"
}

resource "yandex_kubernetes_cluster" "self" {
  name        = "k8s-${var.k8s_name}"
  description = "description"

  network_id = yandex_vpc_network.self.id

  master {
    zonal {
      zone      = "${yandex_vpc_subnet.self.zone}"
      subnet_id = "${yandex_vpc_subnet.self.id}"
    }

    version = "1.21"

    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

#  service_account_id      = "${yandex_iam_service_account.k8s.id}"
#  node_service_account_id = "${yandex_iam_service_account.k8s_nodes.id}"

  service_account_id      = "aje2vc0fe6jskitrtq68"
  node_service_account_id = "aje2vc0fe6jskitrtq68"
  labels = {
    test       = "true"
  }

  release_channel = "RAPID"
  network_policy_provider = "CALICO"

}
