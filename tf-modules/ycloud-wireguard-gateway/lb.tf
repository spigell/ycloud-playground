
resource "yandex_lb_target_group" "self" {
  name = "vpn"
  target {
    subnet_id = yandex_compute_instance.gw.network_interface[0].subnet_id
    address   = yandex_compute_instance.gw.network_interface[0].ip_address
  }
}

resource "yandex_lb_network_load_balancer" "self" {
  name = "vpn"

  listener {
    name     = "my-listener"
    port     = 51820
    protocol = "udp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.self.id
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

resource "yandex_vpc_security_group_rule" "web" {
  security_group_binding = yandex_vpc_security_group.gw.id
  direction              = "ingress"
  predefined_target      = "loadbalancer_healthchecks"
  port                   = 80
  protocol               = "TCP"
}
