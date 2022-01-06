
locals {
  az = sort(["ru-central1-a", "ru-central1-b", "ru-central1-c"])
}

resource "yandex_vpc_network" "self" {}

resource "yandex_vpc_security_group" "self" {
  description = "description for default security group"
  network_id  = yandex_vpc_network.self.id

  egress {
    protocol       = "ANY"
    description    = "External traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh internal access"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }
}

resource "yandex_vpc_subnet" "default" {
  network_id     = yandex_vpc_network.self.id
  for_each       = toset(local.az)
  v4_cidr_blocks = ["10.255.${index(local.az, each.key)}.224/27"]
  zone           = each.key
}

resource "yandex_vpc_subnet" "with_nat_network" {
  network_id     = yandex_vpc_network.self.id
  for_each       = toset(local.az)
  v4_cidr_blocks = ["10.254.${index(local.az, each.key)}.128/25"]
  zone           = each.key
}
