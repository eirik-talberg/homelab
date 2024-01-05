locals {
  project_root = "${path.module}/../../.."
}

module "master-nodes" {
  source       = "../../../tfmodules/pve-vms"
  nodes        = local.nodes.master
  subnet       = local.subnet
  domain       = local.domain
  pve_hostname = local.pve_hostname
  target_node  = local.target_node
}

module "agent-nodes" {
  source       = "../../../tfmodules/pve-vms"
  nodes        = local.nodes.agent
  subnet       = local.subnet
  domain       = local.domain
  pve_hostname = local.pve_hostname
  target_node  = local.target_node
}

resource "local_file" "ansible_inventory_file" {
  content = templatefile("${local.project_root}/ansible/inventories/k3s_hosts.tftpl", {
    master_nodes = [
      for hostname, values in local.nodes.master :
      "${hostname}.${local.domain} ansible_host=${local.subnet}.${values.vm_id}"
    ]
    agent_nodes  = [
      for hostname, values in local.nodes.agent :
      "${hostname}.${local.domain} ansible_host=${local.subnet}.${values.vm_id}"
    ]
  })
  filename = "${local.project_root}/ansible/inventories/${local.inventory_name}/hosts.ini"
}