resource "proxmox_virtual_environment_vm" "node" {
  name = var.name
  tags = concat(["terraform"], var.tags)

  node_name     = var.pve_node
  vm_id         = var.id
  scsi_hardware = "virtio-scsi-single"

  agent {
    enabled = true
  }
  stop_on_destroy = true

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory
    floating  = var.memory # set equal to dedicated to enable ballooning
  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.image_id
    interface    = "scsi0"
    file_format  = "raw"
    size         = var.disk_size
    aio          = "native"
    cache        = "none"
    discard      = "on"
    iothread     = true
    ssd          = true
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = var.os
  }
}

output "ipv4_address" {
  value       = proxmox_virtual_environment_vm.node.ipv4_addresses[var.pve_node_network_interface_id].0
  sensitive   = false
  description = "IP for created node"
  depends_on  = [proxmox_virtual_environment_vm.node]
}

output "name" {
  value      = proxmox_virtual_environment_vm.node.name
  sensitive  = false
  depends_on = [proxmox_virtual_environment_vm.node]
}
