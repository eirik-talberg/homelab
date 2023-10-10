terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_node}.${var.domain}:8006/api2/json"

  /** Uncomment for debugging
    pm_log_enable = true
    pm_log_file = "terraform-plugin-proxmox.log"
    pm_debug = true
    pm_log_levels = {
      _default = "debug"
      _capturelog = ""
    }
  */

}
resource "local_file" "cloud_init_user_data_file" {
  for_each = var.nodes
  content  = templatefile("${path.module}/files/cloud_init.tftpl", {
    pubkey           = file(pathexpand("~/.ssh/id_rsa.pub"))
    node_user        = var.node_user
    node_gecos       = var.node_gecos
    hostname         = each.key
    install_packages = var.install_packages
    storage_disk     = each.value.storage_disk
    domain           = var.domain
  })
  filename = "/tmp/${each.key}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  for_each = var.nodes
  connection {
    type        = "ssh"
    user        = var.pve_user
    host        = "${var.pve_node}.${var.domain}"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[each.key].filename
    destination = "/var/lib/vz/snippets/${each.key}.yml"
  }
}

resource "proxmox_vm_qemu" "vms" {
  for_each   = var.nodes
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  name        = each.key
  target_node = var.target_node
  vmid        = each.value.vm_id
  clone       = var.template_name

  qemu_os   = "l26"
  agent     = 1
  cores     = each.value.cores
  sockets   = each.value.sockets
  memory    = each.value.memory
  scsihw    = "virtio-scsi-single"
  os_type   = "cloud-init"
  ipconfig0 = "gw=${var.gateway},ip=${var.subnet}.${each.value.vm_id}/16"

  cicustom                = "user=local:snippets/${each.key}.yml"
  cloudinit_cdrom_storage = var.storage_pool

  # OS disk, sda
  disk {
    storage  = var.storage_pool
    type     = each.value.os_disk.type
    size     = each.value.os_disk.size
    iothread = each.value.os_disk.io_thread
    discard  = each.value.os_disk.discard
    ssd      = each.value.os_disk.ssd
  }

  # Mass storage, sdb
  dynamic "disk" {
    # This syntax is weird
    for_each = each.value.storage_disk != null ? [1] : []
    content {
      storage  = var.storage_pool
      type     = each.value.storage_disk.type
      size     = each.value.storage_disk.size
      iothread = each.value.storage_disk.io_thread
      discard  = each.value.storage_disk.discard
      ssd      = each.value.storage_disk.ssd
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }
}
