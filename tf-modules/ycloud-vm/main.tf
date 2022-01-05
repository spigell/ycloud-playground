terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

resource "yandex_iam_service_account" "self" {
  name = "vmmanager"
}

resource "yandex_resourcemanager_folder_iam_member" "self" {
  folder_id = var.folder_id
  role      = "compute.admin"
  member    = "serviceAccount:${yandex_iam_service_account.self.id}"
}

resource "yandex_vpc_network" "self" {}

resource "yandex_vpc_subnet" "self" {
  network_id     = yandex_vpc_network.self.id
  v4_cidr_blocks = ["10.255.0.224/27"]
}

resource "yandex_compute_instance" "win" {
  name               = "win"
  service_account_id = yandex_iam_service_account.self.id

  allow_stopping_for_update = true

  platform_id = "standard-v1"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8o9mhciuq6s37vio5h"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.self.id
    nat       = false
  }
  metadata = {
    serial-port-enable = 1
  }
}

resource "yandex_compute_instance" "linux" {
  name               = "linux"
  service_account_id = yandex_iam_service_account.self.id

  allow_stopping_for_update = true

  platform_id = "standard-v2"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8toc5ftgd05qvrah9l"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.self.id
    nat       = true
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys = "cloud-user:${file("files/id_rsa.pub")}"
  }
}
