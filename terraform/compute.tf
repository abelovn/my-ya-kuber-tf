resource "yandex_compute_instance" "master" {
  name        = "master"
  zone        = var.yc_zones
  hostname    = "master"
  platform_id = "standard-v2"
  resources {
    cores  = 4
    memory = 8
    #core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
      type     = "network-ssd"
      size     = 16
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnet.id
    nat       = true
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
    cores  = 4
    memory = 8
    #core_fraction = 50
  }

  boot_disk {
    initialize_params {
      image_id = "fd82sqrj4uk9j7vlki3q"
      type     = "network-ssd"
      size     = 16
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.k8s_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data = "#cloud-config\nhostname: worker${count.index}"
  }
}

