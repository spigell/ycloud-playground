
resource "yandex_mdb_greenplum_cluster" "personal_1" {
  name               = "personal-1"
  description        = "test greenplum cluster"
  environment        = "PRESTABLE"
  network_id         = var.network_id
  zone               = "ru-central1-a"
  subnet_id          = var.subnets["ru-central1-a"].id
  assign_public_ip   = false
  version            = "6.17"
  master_host_count  = 2
  segment_host_count = 4
  segment_in_host    = 1
  master_subcluster {
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 24
      disk_type_id       = "network-ssd"
    }
  }
  segment_subcluster {
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 36
      disk_type_id       = "network-ssd"
    }
  }

  access {
    web_sql = true
  }

  user_name     = "mygpadmin"
  user_password = "123456789"
}
