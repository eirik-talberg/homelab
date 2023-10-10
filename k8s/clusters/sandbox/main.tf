locals {
  project_root = "${path.module}/../../.."
}

module "master-nodes" {
  source = "../../../tfmodules/pve-vms"
  nodes  = local.nodes.master
  subnet = local.subnet
  domain = local.domain
}

module "agent-nodes" {
  source = "../../../tfmodules/pve-vms"
  nodes  = local.nodes.agent
  subnet = local.subnet
  domain = local.domain
}

resource "local_file" "ansible_inventory_file" {
  content = templatefile("${local.project_root}/ansible/inventories/k3s_hosts.tftpl", {
    domain       = local.domain
    master_nodes = [for hostname, values in local.nodes.master : hostname]
    agent_nodes  = [for hostname, values in local.nodes.agent : hostname]
  })
  filename = "${local.project_root}/ansible/inventories/${local.inventory_name}/hosts.ini"
}


