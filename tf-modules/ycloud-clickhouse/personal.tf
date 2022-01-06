
locals {
  zone = "ru-central1-a"
}
resource "yandex_mdb_clickhouse_cluster" "personal_1" {
  deletion_protection     = false
  environment             = "PRODUCTION"
  name                    = "personal-testing-1"
  network_id              = var.network_id
  security_group_ids      = []
  service_account_id      = "aje6ar6grja2uau5prob"
  sql_database_management = false
  sql_user_management     = false
  version                 = "21.8"

  access {
    data_lens  = false
    metrika    = false
    serverless = false
    web_sql    = false
  }

  backup_window_start {
    hours   = 22
    minutes = 0
  }

  clickhouse {
    config {
      background_pool_size            = 0
      background_schedule_pool_size   = 0
      keep_alive_timeout              = 3
      log_level                       = "DEBUG"
      mark_cache_size                 = 5368709120
      max_concurrent_queries          = 500
      max_connections                 = 4096
      max_partition_size_to_drop      = 53687091200
      max_table_size_to_drop          = 53687091200
      metric_log_enabled              = true
      metric_log_retention_size       = 536870912
      metric_log_retention_time       = 2592000000
      part_log_retention_size         = 536870912
      part_log_retention_time         = 2592000000
      query_log_retention_size        = 1073741824
      query_log_retention_time        = 2592000000
      query_thread_log_enabled        = true
      query_thread_log_retention_size = 536870912
      query_thread_log_retention_time = 2592000000
      text_log_enabled                = false
      text_log_level                  = "TRACE"
      text_log_retention_size         = 536870912
      text_log_retention_time         = 2592000000
      timezone                        = "Europe/Moscow"
      trace_log_enabled               = true
      trace_log_retention_size        = 536870912
      trace_log_retention_time        = 2592000000
      uncompressed_cache_size         = 8589934592

      kafka {
        sasl_mechanism    = "SASL_MECHANISM_UNSPECIFIED"
        security_protocol = "SECURITY_PROTOCOL_UNSPECIFIED"
      }

      merge_tree {
        max_bytes_to_merge_at_min_space_in_pool                   = 1048576
        max_replicated_merges_in_queue                            = 16
        number_of_free_entries_in_pool_to_lower_max_size_of_merge = 8
        parts_to_delay_insert                                     = 150
        parts_to_throw_insert                                     = 300
        replicated_deduplication_window                           = 100
        replicated_deduplication_window_seconds                   = 604800
      }
    }

    resources {
      disk_size          = 20
      disk_type_id       = "network-hdd"
      resource_preset_id = "s2.medium"
    }
  }

  host {
    assign_public_ip = false
    shard_name       = "shard1"
    subnet_id        = var.subnets[local.zone].id
    type             = "CLICKHOUSE"
    zone             = local.zone
  }

  maintenance_window {
    type = "ANYTIME"
  }

  timeouts {}

  zookeeper {
    resources {
      disk_size = 0
    }
  }
}
