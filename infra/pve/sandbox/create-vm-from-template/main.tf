locals {
  project_root = "${path.module}/../../.."
}

module "nodes" {
  source       = "../../../../tfmodules/pve-vms"
  nodes        = local.nodes
  subnet       = local.subnet
  domain       = local.domain
  pve_hostname = local.pve_hostname
  target_node  = local.target_node
}

