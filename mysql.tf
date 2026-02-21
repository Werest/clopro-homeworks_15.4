# Создание кластера MySQL в Yandex Managed Service for MySQL
resource "yandex_mdb_mysql_cluster" "netology_mysql" {
  name                = "netology-mysql-cluster"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.main.id
  version             = "8.0"
  deletion_protection = true

  # Ресурсы, выделяемые для кластера (применяются ко всем хостам)
  resources {
    resource_preset_id = "b1.medium"  # Intel Broadwell, 50% CPU
    disk_type_id       = "network-hdd"
    disk_size          = 20  # GB
  }

  # Динамическое создание хостов в разных зонах доступности
  # Количество хостов определяется количеством приватных подсетей (2 шт.)
  dynamic "host" {
    for_each = yandex_vpc_subnet.mysql_private
    content {
      zone      = host.value.zone
      subnet_id = host.value.id
    }
  }

  # Окно технического обслуживания (когда можно применять обновления)
  maintenance_window {
    type = "ANYTIME"
  }

  # Время начала резервного копирования
  backup_window_start {
    hours   = 23
    minutes = 59
  }

  # Создание базы данных внутри кластера
  database {
    name = "netology_db"
  }

  # Создание пользователя для доступа к базе данных
  user {
    name     = "netology_user"
    password = var.mysql_password
    # Права доступа пользователя
    permission {
      database_name = "netology_db"
      roles         = ["ALL"]
    }
  }
}