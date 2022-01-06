
locals {
  zone = "ru-central1-b"
}

resource "yandex_mdb_kafka_cluster" "debezium_1" {
  count               = var.kafka_with_debezium ? 1 : 0
  environment         = "PRESTABLE"
  name                = "debezium-testing-1"
  network_id          = var.network_id
  deletion_protection = true
  subnet_ids          = [var.subnets[local.zone].id]

  config {
    assign_public_ip = false
    brokers_count    = 1
    version          = "2.8"
    schema_registry  = true
    kafka {
      resources {
        disk_size          = 20
        disk_type_id       = "network-hdd"
        resource_preset_id = "s2.micro"
      }
    }

    zones = [
      local.zone
    ]
  }

  user {
    name     = "debezium"
    password = "debezium_password"
    permission {
      topic_name = "mpg.public.measurements"
      role       = "ACCESS_ROLE_CONSUMER"
    }
    permission {
      topic_name = "mpg.public.measurements"
      role       = "ACCESS_ROLE_PRODUCER"
    }
    permission {
      topic_name = "__debezium-heartbeat.mpg"
      role       = "ACCESS_ROLE_PRODUCER"
    }
    permission {
      topic_name = "__debezium-heartbeat.mpg"
      role       = "ACCESS_ROLE_PRODUCER"
    }
  }
}


resource "yandex_mdb_kafka_topic" "debezium_1_heartbeat" {
  count              = var.kafka_with_debezium ? 1 : 0
  cluster_id         = yandex_mdb_kafka_cluster.debezium_1[0].id
  name               = "__debezium-heartbeat.mpg"
  partitions         = 4
  replication_factor = 1
  topic_config {
    cleanup_policy        = "CLEANUP_POLICY_COMPACT"
    compression_type      = "COMPRESSION_TYPE_LZ4"
    delete_retention_ms   = 86400000
    file_delete_delay_ms  = 60000
    flush_messages        = 128
    flush_ms              = 1000
    min_compaction_lag_ms = 0
    retention_bytes       = 10737418240
    retention_ms          = 604800000
    max_message_bytes     = 1048588
    min_insync_replicas   = 1
    segment_bytes         = 268435456
    preallocate           = true
  }
}

resource "yandex_mdb_kafka_topic" "debezium_1_data" {
  count              = var.kafka_with_debezium ? 1 : 0
  cluster_id         = yandex_mdb_kafka_cluster.debezium_1[0].id
  name               = "mpg.public.measurements"
  partitions         = 4
  replication_factor = 1
  topic_config {
    cleanup_policy        = "CLEANUP_POLICY_COMPACT"
    compression_type      = "COMPRESSION_TYPE_LZ4"
    delete_retention_ms   = 86400000
    file_delete_delay_ms  = 60000
    flush_messages        = 128
    flush_ms              = 1000
    min_compaction_lag_ms = 0
    retention_bytes       = 10737418240
    retention_ms          = 604800000
    max_message_bytes     = 1048588
    min_insync_replicas   = 1
    segment_bytes         = 268435456
    preallocate           = true
  }
}
