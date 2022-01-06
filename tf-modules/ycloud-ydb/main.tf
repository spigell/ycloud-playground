
resource "yandex_ydb_database_dedicated" "personal_1" {
  count = var.ydb_with_dedicated ? 1 : 0
  name  = "dedicated-personal-testing-1"

  network_id         = var.network_id
  subnet_ids         = [for n, s in var.subnets : s.id]
  resource_preset_id = "medium"

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  storage_config {
    group_count     = 1
    storage_type_id = "ssd"
  }

  location {
    region {
      id = "ru-central1"
    }
  }
}

resource "yandex_ydb_database_serverless" "personal_1" {
  name  = "serverless-personal-testing-1"
  count = var.ydb_with_serverless ? 1 : 0
}
