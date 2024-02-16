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



resource "yandex_compute_instance" "master" {
  name        = "master"
  zone        = var.yc_zones
  hostname    = "master"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnet.id
    nat       = true
    #security_group_ids = [yandex_vpc_security_group.master_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: master"
  }
}

resource "yandex_compute_instance" "worker" {
  count       = 2
  name        = "worker-${count.index}"
  zone        = var.yc_zones
  hostname    = "worker-${count.index}"
  platform_id = "standard-v2"
  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnet.id
    nat       = false
    #security_group_ids = [yandex_vpc_security_group.worker_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: worker${count.index}"
  }
}


