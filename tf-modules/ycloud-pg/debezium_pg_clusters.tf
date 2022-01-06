
resource "yandex_mdb_postgresql_cluster" "debezium_1" {
  count               = var.pg_with_debezium ? 1 : 0
  name                = "debezium-testing-1"
  description         = "Simple cluster for depezium testing"
  environment         = "PRESTABLE"
  network_id          = var.network_id
  deletion_protection = false


  config {
    version = "14"
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 10
      disk_type_id       = "network-ssd"
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
    name       = "debezium"
    password   = "debezium_password"
    conn_limit = 10
    grants     = ["mdb_replication"]
  }

  host_master_name = "a"

  host {
    name      = "a"
    zone      = "ru-central1-b"
    subnet_id = var.subnets["ru-central1-b"].id
  }

  host {
    name      = "b"
    zone      = "ru-central1-b"
    subnet_id = var.subnets["ru-central1-b"].id
  }

  database {
    owner = "debezium"
    name  = "debezium"
  }
}
