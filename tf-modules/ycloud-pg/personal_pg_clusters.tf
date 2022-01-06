
resource "random_password" "passwords" {
  count   = 2
  length  = 16
  special = true
}

resource "yandex_mdb_postgresql_cluster" "personal_1" {
  count               = var.pg_with_personal ? 1 : 0
  name                = "personal-testing-1"
  description         = "Simple HA cluster for testing"
  environment         = "PRESTABLE"
  network_id          = var.network_id
  deletion_protection = true


  config {
    version = "14"
    resources {
      resource_preset_id = "b2.medium"
      disk_size          = 10
      disk_type_id       = "network-hdd"
    }

    access {
      web_sql = true
    }

    postgresql_config = {
      max_connections                   = 200
      enable_parallel_hash              = true
      vacuum_cleanup_index_scale_factor = 0.2
      autovacuum_vacuum_scale_factor    = 0.32
      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
      force_parallel_mode               = "FORCE_PARALLEL_MODE_ON"
      synchronous_commit                = "SYNCHRONOUS_COMMIT_OFF"
    }

    pooler_config {
      pool_discard = true
      pooling_mode = "SESSION"
    }
  }

  user {
    name       = "user"
    password   = random_password.passwords[0].result
    conn_limit = 10
  }

  user {
    name       = "mypgadmin"
    password   = "123456789"
    conn_limit = 10
    grants     = ["mdb_admin", "mdb_replication"]
  }

  host_master_name = "b"

  host {
    name      = "a"
    zone      = "ru-central1-b"
    subnet_id = var.subnets["ru-central1-b"].id
  }
  host {
    name      = "b"
    zone      = "ru-central1-a"
    subnet_id = var.subnets["ru-central1-a"].id
  }
  host {
    name      = "c"
    zone      = "ru-central1-c"
    subnet_id = var.subnets["ru-central1-c"].id
  }

  database {
    owner = "mypgadmin"
    name  = "mydb"
  }
  database {
    owner = "user"
    name  = "userdb"
  }
}
