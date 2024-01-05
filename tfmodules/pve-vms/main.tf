terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://${var.pve_hostname}.${var.domain}/api2/json" # TODO CHANGE

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
    domain           = var.domain
  })
  filename = "/tmp/${each.key}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  for_each = var.nodes
  connection {
    type        = "ssh"
    user        = var.pve_user
    host        = "${var.target_node}.${var.domain}"
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

  //Common defaults
  target_node             = var.target_node
  os_type                 = "cloud-init"
  scsihw                  = "virtio-scsi-single" //Not settable in template?
  cloudinit_cdrom_storage = var.storage_pool
  cores                   = 0 //Ensures that we use the template value
  memory                  = 0 //Ensures that we use the template value

  //Node specific values
  name      = each.key
  vmid      = each.value.vm_id
  clone     = each.value.template
  ipconfig0 = "gw=${var.gateway},ip=${var.subnet}.${each.value.vm_id}/16"
  cicustom  = "user=local:snippets/${each.key}.yml"


}
