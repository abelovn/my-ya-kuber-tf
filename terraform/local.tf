resource "local_file" "ansible_inventory" {
  filename        = "../ansible/inventory.ini"
  file_permission = 0644
  content = templatefile("./inventory.tftpl",
    {
      master_nat_ip_address_list = yandex_compute_instance.master[*].network_interface[0].nat_ip_address
      master_ip_address_list     = yandex_compute_instance.master[*].network_interface[0].ip_address
      master_vm_names            = yandex_compute_instance.master[*].name
	  
	  
      worker_ip_address_list     = yandex_compute_instance.worker[*].network_interface[0].ip_address
      worker_vm_names            = yandex_compute_instance.worker[*].name
	  
    }
  )
}

resource "local_file" "ansible_config" {
  filename        = "../ansible/ansible.cfg"
  file_permission = 0644
  content = templatefile("./ansible.cfg.tftpl",
    {
      master_nat_ip_address = yandex_compute_instance.master.network_interface[0].nat_ip_address
    }
  )
}
