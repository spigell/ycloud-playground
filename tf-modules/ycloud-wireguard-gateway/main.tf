
data "yandex_compute_image" "coi" {
  family = "container-optimized-image"
}

resource "yandex_vpc_address" "gw" {
  external_ipv4_address {
    zone_id = var.zone
  }
}

resource "yandex_vpc_security_group" "gw" {
  description = "Gateway group"
  network_id  = var.network_id
}

resource "yandex_vpc_security_group_rule" "wireguard" {
  security_group_binding = yandex_vpc_security_group.gw.id
  direction              = "ingress"
  protocol               = "UDP"
  description            = "rule1 description"
  v4_cidr_blocks         = ["0.0.0.0/0"]
  port                   = 51820
}

resource "yandex_compute_instance" "gw" {
  zone = var.zone

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
    subnet_id      = var.subnets[var.zone].id
    nat            = true
    nat_ip_address = yandex_vpc_address.gw.external_ipv4_address[0].address
    security_group_ids = [
      var.base_security_group_id,
      yandex_vpc_security_group.gw.id
    ]
  }

  metadata = {
    serial-port-enable = 1
    docker-compose     = templatefile("gw.yml.tmpl", { ip = yandex_vpc_address.gw.external_ipv4_address[0].address })
    user-data          = templatefile("cloud_config.yml.tmpl", { key = "${var.ssh_key}" })
  }
}
