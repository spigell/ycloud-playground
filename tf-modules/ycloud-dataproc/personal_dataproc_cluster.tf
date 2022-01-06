
locals {
  name               = "personal-dataproc-testing-10"
  zone_id            = "ru-central1-b"
  resource_preset_id = "s2.micro"
  disk_type_id       = "network-hdd"
  disk_size          = 20
  subnet_id          = var.subnets[local.zone_id].id
}

resource "yandex_storage_bucket" "dataproc_personal_1" {
  count      = var.dataproc_with_personal ? 1 : 0
  bucket     = format("agent-%s", local.name)
  secret_key = var.s3_secret_key
  access_key = var.s3_access_key
}

resource "yandex_dataproc_cluster" "personal_1" {
  count               = var.dataproc_with_personal ? 1 : 0
  deletion_protection = true
  bucket              = yandex_storage_bucket.dataproc_personal_1[0].bucket
  description         = "Personal Dataproc cluster 1"
  name                = local.name
  service_account_id  = yandex_iam_service_account.agent.id
  zone_id             = local.zone_id

  cluster_config {
    # Certain cluster version can be set, but better to use default value (last stable version)
    version_id = "2.0"

    hadoop {
      services = ["HDFS", "YARN", "SPARK", "TEZ", "MAPREDUCE", "HIVE"]
      properties = {
        "yarn:yarn.resourcemanager.am.max-attempts" = 5
      }
      ssh_public_keys = [var.ssh_key]
    }

    subcluster_spec {
      name = "main"
      role = "MASTERNODE"
      resources {
        resource_preset_id = local.resource_preset_id
        disk_type_id       = local.disk_type_id
        disk_size          = 25
      }
      subnet_id   = local.subnet_id
      hosts_count = 1
    }

    subcluster_spec {
      name = "data"
      role = "DATANODE"
      resources {
        resource_preset_id = local.resource_preset_id
        disk_type_id       = local.disk_type_id
        disk_size          = local.disk_size
      }
      subnet_id   = local.subnet_id
      hosts_count = 2
    }

    subcluster_spec {
      name = "compute"
      role = "COMPUTENODE"
      resources {
        resource_preset_id = local.resource_preset_id
        disk_type_id       = local.disk_type_id
        disk_size          = local.disk_size
      }
      subnet_id   = local.subnet_id
      hosts_count = 2
    }

    subcluster_spec {
      name = "compute_autoscaling"
      role = "COMPUTENODE"
      resources {
        resource_preset_id = local.resource_preset_id
        disk_type_id       = local.disk_type_id
        disk_size          = local.disk_size
      }
      subnet_id   = local.subnet_id
      hosts_count = 2
      autoscaling_config {
        max_hosts_count        = 10
        measurement_duration   = 60
        warmup_duration        = 60
        stabilization_duration = 120
        preemptible            = false
        decommission_timeout   = 60
      }
    }
  }
  depends_on = [yandex_resourcemanager_folder_iam_member.agent,
    yandex_resourcemanager_folder_iam_member.agent_with_compute_admin
  ]
}
