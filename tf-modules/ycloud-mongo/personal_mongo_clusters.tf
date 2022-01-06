
resource "yandex_mdb_mongodb_cluster" "personal_1" {
  name        = "personal-mongo-testing-1"
  environment = "PRESTABLE"
  network_id  = var.network_id

  cluster_config {
    version = "4.2"
  }

  database {
    name = "mydb"
  }

  user {
    name     = "mymongoadmin"
    password = var.admin_password
    permission {
      database_name = "mydb"
      roles         = ["mdbDbAdmin"]
    }
    permission {
      database_name = "admin"
      roles         = ["mdbShardingManager", "mdbMonitor"]
    }
  }

  resources {
    resource_preset_id = "s2.micro"
    disk_size          = 10
    disk_type_id       = "network-hdd"
  }

  dynamic "host" {
    for_each = [1, 2, 3]
    content {
      zone_id   = "ru-central1-a"
      subnet_id = var.subnets["ru-central1-a"].id
    }
  }

}
