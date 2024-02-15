output "control_plane_ip" {
  value = yandex_compute_instance.control_plane.network_interface.0.nat_ip_address
}

output "worker_node_ips" {
  value = yandex_compute_instance.worker_node.*.network_interface.0.nat_ip_address
}

