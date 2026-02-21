# Создание сервисного аккаунта для узлов Kubernetes
# Этот аккаунт будет использоваться узлами кластера для доступа к ресурсам Yandex Cloud
resource "yandex_iam_service_account" "k8s_nodes" {
  name        = "k8s-nodes-sa"
  description = "Service account for Kubernetes nodes"
}

# Назначение прав сервисному аккаунту
# Используем for_each для назначения нескольких ролей одной конструкцией
resource "yandex_resourcemanager_folder_iam_member" "k8s_nodes_permissions" {
  for_each = toset([
    "container-registry.images.puller",
    "monitoring.editor",
    "logging.writer",
    "kms.keys.encrypterDecrypter"
  ])
  folder_id = var.folder_id
  role      = each.key
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}

# Назначение роли для управления кластерами Kubernetes
resource "yandex_resourcemanager_folder_iam_member" "k8s_admin" {
  folder_id = var.folder_id
  role      = "k8s.clusters.agent"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}

# Назначение роли для управления публичным доступом в VPC
resource "yandex_resourcemanager_folder_iam_member" "vpc_public_admin" {
  folder_id = var.folder_id
  role      = "vpc.publicAdmin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}

# Назначение роли для управления балансировщиками нагрузки
resource "yandex_resourcemanager_folder_iam_member" "load_balancer_admin" {
  folder_id = var.folder_id
  role      = "load-balancer.admin"
  member    = "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
}