# Создание кластера Kubernetes в Yandex Managed Service for Kubernetes
resource "yandex_kubernetes_cluster" "netology_k8s" {
  name        = "netology-k8s-cluster"
  description = "Kubernetes cluster for Netology homework"
  network_id  = yandex_vpc_network.main.id

  # Диапазоны IP-адресов для внутренней сети кластера
  cluster_ipv4_range = "10.1.0.0/16"
  service_ipv4_range = "10.2.0.0/16"
  node_ipv4_cidr_mask_size = 24

  # Конфигурация мастер-узла
  master {
    version   = "1.31"
    public_ip = true

    # Региональный мастер (размещается в трёх зонах для отказоустойчивости)
    regional {
      region = "ru-central1"

      location {
        zone      = var.zones[0]
        subnet_id = yandex_vpc_subnet.k8s_public[0].id
      }

      location {
        zone      = var.zones[1]
        subnet_id = yandex_vpc_subnet.k8s_public[1].id
      }

      location {
        zone      = var.zones[2]
        subnet_id = yandex_vpc_subnet.k8s_public[2].id
      }
    }

    # Политика обслуживания
    maintenance_policy {
      auto_upgrade = true
      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }

  # Сервисные аккаунты для кластера и узлов
  service_account_id      = yandex_iam_service_account.k8s_nodes.id
  node_service_account_id = yandex_iam_service_account.k8s_nodes.id

  # Настройка шифрования с помощью KMS
  kms_provider {
    key_id = yandex_kms_symmetric_key.k8s_key.id
  }

  depends_on = [
    yandex_resourcemanager_folder_iam_member.k8s_nodes_permissions,
    yandex_resourcemanager_folder_iam_member.k8s_admin,
    yandex_resourcemanager_folder_iam_member.vpc_public_admin,
    yandex_resourcemanager_folder_iam_member.load_balancer_admin,
    yandex_kms_symmetric_key_iam_binding.k8s_key_encrypter_decrypter
  ]
}

# Создание группы узлов (воркеров) Kubernetes
resource "yandex_kubernetes_node_group" "netology_nodes" {
  cluster_id = yandex_kubernetes_cluster.netology_k8s.id
  name       = "netology-node-group"

  # Шаблон виртуальной машины для узлов
  instance_template {
    platform_id = "standard-v2"

    # Сетевые интерфейсы
    network_interface {
      nat        = true
      # Используем подсеть только для первой зоны
      subnet_ids = [yandex_vpc_subnet.k8s_public[0].id]
    }

    # Ресурсы виртуальной машины
    resources {
      memory = 4
      cores  = 2
    }

    # Загрузочный диск
    boot_disk {
      type = "network-hdd"
      size = 64
    }

    # Политика планирования
    scheduling_policy {
      preemptible = false
    }

    # Тип container runtime
    container_runtime {
      type = "containerd"
    }
  }

  # Политика масштабирования — автоматическое масштабирование
  scale_policy {
    auto_scale {
      min     = 3
      max     = 6
      initial = 3
    }
  }

  # Политика размещения — только одна зона (обязательно для auto_scale)
  allocation_policy {
    # Только одна зона
    location {
      zone = var.zones[0]
    }
  }

  # Политика обслуживания
  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    # Окна обслуживания — по понедельникам, вторникам и средам в 23:00 на 3 часа
    maintenance_window {
      day        = "monday"
      start_time = "23:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "tuesday"
      start_time = "23:00"
      duration   = "3h"
    }

    maintenance_window {
      day        = "wednesday"
      start_time = "23:00"
      duration   = "3h"
    }
  }
}

# Провайдер Kubernetes для подключения
provider "kubernetes" {
  host                   = yandex_kubernetes_cluster.netology_k8s.master[0].external_v4_endpoint
  cluster_ca_certificate = base64decode(yandex_kubernetes_cluster.netology_k8s.master[0].cluster_ca_certificate)
  token                  = data.yandex_client_config.client.iam_token
}

# Провайдер Helm для управления Helm-чартами в кластере
provider "helm" {
  kubernetes {
    host                   = yandex_kubernetes_cluster.netology_k8s.master[0].external_v4_endpoint
    cluster_ca_certificate = base64decode(yandex_kubernetes_cluster.netology_k8s.master[0].cluster_ca_certificate)
    token                  = data.yandex_client_config.client.iam_token
  }
}

# Получение конфигурации текущего клиента Yandex Cloud (для IAM-токена)
data "yandex_client_config" "client" {}