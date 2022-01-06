
resource "yandex_compute_instance" "personal_1" {
  name               = "personal-testing-1"
  service_account_id = yandex_iam_service_account.compute_worker.id
  zone               = var.personal_zone

  allow_stopping_for_update = true
  hostname                  = "gateway"

  platform_id = "standard-v2"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 1
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.coi.id
    }
  }
  network_interface {
    subnet_id = var.subnets[var.personal_zone].id
  }
  metadata = {
    serial-port-enable = 1
    user-data          = templatefile("files/cloud_config.yml.tmpl", { key = "${var.ssh_key}" })
  }
}

resource "yandex_compute_snapshot" "personal_1" {
  name           = "auto-snapshot"
  source_disk_id = yandex_compute_instance.personal_1.boot_disk[0].disk_id
}

resource "yandex_compute_instance" "restored_personal_1" {
  name               = "restored-personal-testing-1"
  service_account_id = yandex_iam_service_account.compute_worker.id
  zone               = var.personal_zone

  allow_stopping_for_update = true

  platform_id = "standard-v2"

  resources {
    cores         = 2
    core_fraction = 20
    memory        = 1
  }

  boot_disk {
    initialize_params {
      snapshot_id = yandex_compute_snapshot.personal_1.id
    }
  }
  network_interface {
    subnet_id = var.subnets[var.personal_zone].id
  }
}
