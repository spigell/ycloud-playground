
output "mysql_personal_1_master_host" {
  value = format("c-%s.rw.mdb.yandexcloud.net", yandex_mdb_mysql_cluster.personal_1.id)
}

output "mysql_personal_1_replica_host" {
  value = format("c-%s.ro.mdb.yandexcloud.net", yandex_mdb_mysql_cluster.personal_1.id)
}
