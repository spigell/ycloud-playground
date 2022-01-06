
# resource "yandex_lb_network_load_balancer" "self" {
#   name = "web-backends"

#   listener {
#     name = "my-listener"
#     port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }

#   attached_target_group {
#     target_group_id = (var.vm_management == "group" ?
#       yandex_compute_instance_group.vm[0].load_balancer[0].target_group_id
#     : yandex_lb_target_group.vm[0].id)

#     healthcheck {
#       name = "http"
#       tcp_options {
#         port = 80
#       }
#     }
#   }
# }


resource "yandex_alb_http_router" "web" {
  name = "web-router"
}

resource "yandex_alb_backend_group" "web-backend-group" {
  name = "my-backend-group"

  http_backend {
    name   = "test-http-backend"
    weight = 1
    port   = 80
    target_group_ids = [(var.vm_management == "group" ?
      yandex_compute_instance_group.vm[0].application_load_balancer[0].target_group_id
    : yandex_lb_target_group.vm[0].id)]

    load_balancing_config {
      panic_threshold = 50
    }
    healthcheck {
      timeout  = "1s"
      interval = "1s"
      http_healthcheck {
        path = "/"
      }
    }
    http2 = "false"
  }
}


resource "yandex_alb_virtual_host" "my-virtual-host" {
  name           = "my-virtual-host"
  http_router_id = yandex_alb_http_router.web.id
  route {
    name = "my-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web-backend-group.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web_alb" {
  name = "web-alb"

  network_id = var.network_id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = var.subnets["ru-central1-a"].id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "web_alb-b" {
  name = "web-alb-b"

  network_id = var.network_id

  allocation_policy {
    location {
      zone_id   = "ru-central1-b"
      subnet_id = var.subnets["ru-central1-b"].id
    }
  }

  listener {
    name = "my-listener"
    endpoint {
      address {
        external_ipv4_address {
        }
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }
}
