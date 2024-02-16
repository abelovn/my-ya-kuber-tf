resource "yandex_vpc_security_group" "worker_node_sg" {
  name       = "worker-node-sg"
  network_id = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes worker nodes"
}

resource "yandex_vpc_security_group_rule" "worker_kubelet_api" {
  security_group_binding = yandex_vpc_security_group.worker_node_sg.id
  direction              = "ingress"
  description            = "Kubelet API"
  protocol               = "tcp"
  from_port              = 10250
  to_port                = 10250
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "nodeport_services_tcp" {
  security_group_binding = yandex_vpc_security_group.worker_node_sg.id
  direction              = "ingress"
  description            = "NodePort Services TCP"
  protocol               = "tcp"
  from_port              = 30000
  to_port                = 32767
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "nodeport_services_udp" {
  security_group_binding = yandex_vpc_security_group.worker_node_sg.id
  direction              = "ingress"
  description            = "NodePort Services UDP"
  protocol               = "udp"
  from_port              = 30000
  to_port                = 32767
  v4_cidr_blocks         = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "worker_node_ssh" {
  security_group_binding = yandex_vpc_security_group.worker_node_sg.id
  direction              = "ingress"
  description            = "SSH"
  protocol               = "tcp"
  port                   = 22
  v4_cidr_blocks         = ["0.0.0.0/0"]  # Consider restricting this to known IPs for better security
}

