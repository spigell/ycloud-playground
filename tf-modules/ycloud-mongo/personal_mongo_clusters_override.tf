
resource "yandex_mdb_mongodb_cluster" "personal_1" {

  dynamic "host" {
    for_each = [1, 2, 3]
    content {
      zone_id   = "ru-central1-a"
      subnet_id = var.subnets["ru-central1-a"].id
    }
  }

  host {
    zone_id   = "ru-central1-b"
    subnet_id = var.subnets["ru-central1-b"].id
  }

  host {
    assign_public_ip = false
    role             = "PRIMARY"
    subnet_id        = "e2lagaiv9ighj4q450tv"
    type             = "MONGOINFRA"
    zone_id          = "ru-central1-b"
  }
  host {
    assign_public_ip = false
    role             = "PRIMARY"
    subnet_id        = "e2lagaiv9ighj4q450tv"
    type             = "MONGOINFRA"
    zone_id          = "ru-central1-b"
  }
  host {
    assign_public_ip = false
    role             = "PRIMARY"
    subnet_id        = "e9bha3i4p9c3229odooa"
    type             = "MONGOINFRA"
    zone_id          = "ru-central1-a"
  }

}
