resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.ini"
  file_permission = 0644
  content = templatefile("./inventory.tftpl",
    {
      control_plane_nat_ip_address_list = yandex_compute_instance.control_plane[*].network_interface[0].nat_ip_address
      control_plane_ip_address_list     = yandex_compute_instance.control_plane[*].network_interface[0].ip_address
      control_plane_vm_names            = yandex_compute_instance.control_plane[*].name
	  
	  
      worker_node_ip_address_list     = yandex_compute_instance.worker_node[*].network_interface[0].ip_address
      worker_node_vm_names            = yandex_compute_instance.worker_node[*].name
	  
    }
  )
}

resource "local_file" "ansible_config" {
  filename        = "../ansible/ansible.cfg"
  file_permission = 0644
  content = templatefile("./ansible.cfg.tftpl",
    {
      control_plane_nat_ip_address = yandex_compute_instance.control_plane.network_interface[0].nat_ip_address
    }
  )
}
