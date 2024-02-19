resource "yandex_vpc_network" "k8s_network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s_subnet" {
  name           = "k8s-subnet"
  zone           = var.yc_zones
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
  route_table_id = yandex_vpc_route_table.main_route_table.id
}

resource "yandex_vpc_gateway" "default_gateway" {
  name = "default-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "main_route_table" {
  name       = "main-route-table"
  network_id = yandex_vpc_network.k8s_network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.default_gateway.id
  }
}

