resource "yandex_vpc_security_group" "control_plane_sg" {
  name        = "control-plane-sg"
  network_id  = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes control plane nodes"
}

resource "yandex_vpc_security_group_rule" "api_server" {
  security_group_id = yandex_vpc_security_group.control_plane_sg.id
  description       = "Kubernetes API Server"
  direction         = "INGRESS"
  protocol          = "tcp"
  from_port         = 6443
  to_port           = 6443
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "etcd_api" {
  security_group_id = yandex_vpc_security_group.control_plane_sg.id
  description       = "etcd server client API"
  direction         = "INGRESS"
  protocol          = "tcp"
  from_port         = 2379
  to_port           = 2380
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "kubelet_api" {
  security_group_id = yandex_vpc_security_group.control_plane_sg.id
  description       = "Kubelet API"
  direction         = "INGRESS"
  protocol          = "tcp"
  from_port         = 10250
  to_port           = 10250
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

