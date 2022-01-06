
locals {
  az = ["ru-central1-a", "ru-central1-b"]
}

resource "yandex_mdb_mysql_cluster" "personal_1" {
  name        = "personal-testing-1"
  environment = "PRESTABLE"
  network_id  = var.network_id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 16
  }

  database {
    name = "mysqldb"
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }

  user {
    name     = "mysqladmin"
    password = "123456789"
    permission {
      database_name = "mysqldb"
      roles         = ["ALL"]
    }
  }

  access {
    web_sql = true
  }

  dynamic "host" {
    for_each = local.az
    content {
      zone                    = host.value
      name                    = "nb-${host.key}"
      replication_source_name = host.key == 0 ? null : "nb-${host.key - 1}"
      subnet_id               = var.subnets[local.az[host.key % length(local.az)]].id
    }
  }

}
