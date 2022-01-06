
resource "yandex_compute_instance" "win" {
  name               = "win"
  service_account_id = yandex_iam_service_account.compute_master.id
  zone               = var.win_zone

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
    subnet_id = var.subnets[var.win_zone].id
    nat       = true
    #    security_group_ids = [var.base_security_group_id]
  }
  metadata = {
    serial-port-enable = 1
    user-data          = "#ps1\nnet user Administrator changeit"
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_member.compute_admin
  ]
}

