resource "yandex_vpc_security_group" "control_plane_sg" {
  name        = "control-plane-sg"
  network_id  = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes control plane nodes"

  rules {
    description = "Kubernetes API Server"
    direction   = "INGRESS"
    protocol    = "tcp"
    port        = [6443]
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  rules {
    description = "etcd server client API"
    direction   = "INGRESS"
    protocol    = "tcp"
    from_port   = 2379
    to_port     = 2380
    cidr_blocks = ["0.0.0.0/0"]
  }

  rules {
    description = "Kubelet API"
    direction   = "INGRESS"
    protocol    = "tcp"
    from_port   = 10250
    to_port     = 10252
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "worker_node_sg" {
  name        = "worker-node-sg"
  network_id  = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes worker nodes"

  rules {
    description = "Kubelet API"
    direction   = "INGRESS"
    protocol    = "tcp"
    from_port   = 10250
    to_port     = 10250
    cidr_blocks = ["0.0.0.0/0"]
  }

  rules {
    description = "NodePort Services"
    direction   = "INGRESS"
    protocol    = "tcp"
    from_port   = 30000
    to_port     = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  rules {
    description = "NodePort Services UDP"
    direction   = "INGRESS"
    protocol    = "udp"
    from_port   = 30000
    to_port     = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }
}
