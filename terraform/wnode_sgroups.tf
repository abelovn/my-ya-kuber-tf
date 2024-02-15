resource "yandex_vpc_security_group" "worker_node_sg" {
  name        = "worker-node-sg"
  network_id  = yandex_vpc_network.k8s_network.id
  description = "Security group for Kubernetes worker nodes"
}

resource "yandex_vpc_security_group_rule" "worker_kubelet_api" {
  security_group_id = yandex_vpc_security_group.worker_node_sg.id
  description       = "Kubelet API"
  direction         = "INGRESS"
  protocol          = "tcp"
  from_port         = 10250
  to_port           = 10250
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "nodeport_services_tcp" {
  security_group_id = yandex_vpc_security_group.worker_node_sg.id
  description       = "NodePort Services TCP"
  direction         = "INGRESS"
  protocol          = "tcp"
  from_port         = 30000
  to_port           = 32767
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

resource "yandex_vpc_security_group_rule" "nodeport_services_udp" {
  security_group_id = yandex_vpc_security_group.worker_node_sg.id
  description       = "NodePort Services UDP"
  direction         = "INGRESS"
  protocol          = "udp"
  from_port         = 30000
  to_port           = 32767
  v4_cidr_blocks    = ["0.0.0.0/0"]
}

