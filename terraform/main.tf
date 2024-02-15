resource "yandex_vpc_network" "k8s_network" {
  name = "k8s-network"
}

resource "yandex_vpc_subnet" "k8s_subnet" {
  name           = "k8s-subnet"
  zone           = var.yc_zones
  network_id     = yandex_vpc_network.k8s_network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_compute_instance" "control_plane" {
  name        = "control-plane"
  zone        = var.yc_zones
  hostname    = "control-plane"
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
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_compute_instance" "worker_node" {
  count       = 2
  name        = "worker-node-${count.index}"
  zone        = var.yc_zones
  hostname    = "worker-node-${count.index}"
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
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}


