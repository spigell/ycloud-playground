
resource "yandex_compute_disk_placement_group" "ssd_nonreplicated" {
  name = "not-replicated"
}

resource "yandex_compute_disk" "ssd_nonreplicated" {
  count = 1
  name  = "non-replicated-disk-name-${count.index}"
  size  = 93 // NB size must be divisible by 93  
  type  = "network-ssd-nonreplicated"
  zone  = "ru-central1-b"

  disk_placement_policy {
    disk_placement_group_id = yandex_compute_disk_placement_group.ssd_nonreplicated.id
  }
}
