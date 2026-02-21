# Создание основной сети VPC
resource "yandex_vpc_network" "main" {
  name        = "netology-network"
  description = "Network for Netology homework"
}

# Приватные подсети для MySQL (в двух зонах доступности)
# Количество подсетей равно количеству зон для MySQL (2)
resource "yandex_vpc_subnet" "mysql_private" {
  count          = 2
  name           = "mysql-private-${count.index}"
  zone           = var.zones[count.index]
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.${10 + count.index}.0/24"]
  route_table_id = yandex_vpc_route_table.nat.id
}

# Публичные подсети для Kubernetes (во всех трёх зонах)
resource "yandex_vpc_subnet" "k8s_public" {
  count          = 3
  name           = "k8s-public-${count.index}"
  zone           = var.zones[count.index]
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = ["10.0.${20 + count.index}.0/24"]
}

# NAT-шлюз для обеспечения доступа в интернет из приватных подсетей
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Таблица маршрутизации для направления трафика из приватных подсетей через NAT-шлюз
resource "yandex_vpc_route_table" "nat" {
  name       = "nat-route-table"
  network_id = yandex_vpc_network.main.id

  # Статический маршрут для всего исходящего трафика (0.0.0.0/0) через NAT-шлюз
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id        = yandex_vpc_gateway.nat_gateway.id
  }
}