
resource "yandex_vpc_security_group" "vm" {
  description = "Web backends"
  network_id  = var.network_id

  ingress {
    protocol          = "TCP"
    description       = "lb access"
    predefined_target = "loadbalancer_healthchecks"
    port              = 80
  }
}

resource "yandex_compute_instance" "vm" {
  count              = var.vm_management == "manual" ? var.vm_count : 0
  name               = "manual-backend-${count.index}"
  service_account_id = yandex_iam_service_account.compute_worker.id
  zone               = var.az[count.index % length(var.az)]

  allow_stopping_for_update = true

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
    subnet_id = var.subnets[var.az[count.index % length(var.az)]].id
    nat       = true
    security_group_ids = [
      var.base_security_group_id,
      yandex_vpc_security_group.vm.id
    ]
  }

  metadata = {
    serial-port-enable = 1
    docker-compose     = file("files/composes/web.yml")
    user-data          = templatefile("files/cloud_config.yml.tmpl", { key = "${var.ssh_key}" })
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_member.lb_admin,
    yandex_resourcemanager_folder_iam_member.vpc_admin,
    yandex_resourcemanager_folder_iam_member.compute_admin
  ]
}

resource "yandex_lb_target_group" "vm" {
  count = var.vm_management == "manual" ? 1 : 0
  name  = "web-backends"

  dynamic "target" {
    for_each = toset(yandex_compute_instance.vm)
    content {
      subnet_id = target.value.network_interface.0.subnet_id
      address   = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_compute_instance_group" "vm" {
  name                = "backends-auto"
  count               = var.vm_management == "group" ? 1 : 0
  service_account_id  = yandex_iam_service_account.compute_master.id
  deletion_protection = false
  instance_template {
    service_account_id = yandex_iam_service_account.compute_worker.id
    platform_id        = "standard-v2"
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.coi.id
      }
    }
    secondary_disk {
      initialize_params {
        size        = 10
        type        = "network-ssd"
        description = "fast ssd network disk"
      }
    }
    network_interface {
      network_id = var.network_id
      subnet_ids = [for n, s in var.subnets : s.id]
      nat        = true
    }
    metadata = {
      serial-port-enable = 1
      docker-compose     = file("files/composes/web.yml")
      user-data          = templatefile("files/cloud_config.yml.tmpl", { key = "${var.ssh_key}" })
    }
    network_settings {
      type = "STANDARD"
    }
  }

  application_load_balancer {
    target_group_name = "lb-auto-backends"
  }

  health_check {
    tcp_options {
      port = 80
      #path = "/"
    }
  }

  scale_policy {
    auto_scale {
      measurement_duration   = 60
      cpu_utilization_target = 80
      initial_size           = 5
      min_zone_size          = 2
      max_size               = 7
    }
  }


  allocation_policy {
    zones = var.az
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 1
    max_expansion   = 1
    max_deleting    = 3
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.compute_admin,
    yandex_resourcemanager_folder_iam_member.vpc_admin,
    yandex_resourcemanager_folder_iam_member.lb_admin
  ]
}
