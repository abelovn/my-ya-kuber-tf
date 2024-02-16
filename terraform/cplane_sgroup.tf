resource "yandex_vpc_security_group" "control_plane_sg" {
  name       = "control-plane-sg"
  network_id = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes control plane nodes"
}

resource "yandex_vpc_security_group_rule" "control_plane_api_server" {
  security_group_binding = yandex_vpc_security_group.control_plane_sg.id
  direction              = "ingress"
  description            = "Kubernetes API Server"
  protocol               = "tcp"
  port                   = 6443
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "control_plane_etcd_api" {
  security_group_binding = yandex_vpc_security_group.control_plane_sg.id
  direction              = "ingress"
  description            = "etcd server client API"
  protocol               = "tcp"
  from_port              = 2379
  to_port                = 2380
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "control_plane_kubelet_api" {
  security_group_binding = yandex_vpc_security_group.control_plane_sg.id
  direction              = "ingress"
  description            = "Kubelet API"
  protocol               = "tcp"
  from_port              = 10250
  to_port                = 10250
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "control_plane_ssh" {
  security_group_binding = yandex_vpc_security_group.control_plane_sg.id
  direction              = "ingress"
  description            = "SSH"
  protocol               = "tcp"
  port                   = 22
  v4_cidr_blocks         = ["0.0.0.0/0"]  # Consider restricting this to known IPs for better security
}

