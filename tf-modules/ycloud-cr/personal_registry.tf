
locals {
  repos = {
    user-container = {
      tag = "v2"
    }
  }
}
resource "yandex_container_registry" "personal_1" {
  name = "personal-testing-1"
}

resource "yandex_container_repository" "personal" {
  for_each = tomap(local.repos)
  name     = "${yandex_container_registry.personal_1.id}/${each.key}"
}


resource "null_resource" "image_creation" {
  for_each = tomap(local.repos)
  triggers = {
    tag = each.value.tag
  }
  provisioner "local-exec" {
    working_dir = "/playground/misc/cr/images"
    command     = "REPO=${each.key} REGISTRY_ID=${yandex_container_registry.personal_1.id} TAG=${each.value.tag} make all"
  }
}
