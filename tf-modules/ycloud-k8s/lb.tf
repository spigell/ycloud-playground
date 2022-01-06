resource "yandex_vpc_address" "gw" {
  external_ipv4_address {
    zone_id = "ru-central1-b"
  }
}

