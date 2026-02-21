output "mysql_cluster_info" {
  value = {
    fqdn          = yandex_mdb_mysql_cluster.netology_mysql.host[0].fqdn
    database_name = "netology_db"
    username      = "netology_user"
  }
  sensitive = true
}

output "k8s_cluster_info" {
  value = {
    endpoint = yandex_kubernetes_cluster.netology_k8s.master[0].external_v4_endpoint
    cluster_id = yandex_kubernetes_cluster.netology_k8s.id
  }
}