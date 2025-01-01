module "talos_cluster_nodes" {
  source          = "../../../../tfmodules/k8s/talos_cluster_nodes"
  controllers     = var.controllers
  workers         = var.workers
  cluster_label   = var.cluster_label
  talos_version   = var.talos_version
  metallb_version = var.metallb_version
  ip_range        = var.ip_range
}

output "nodes" {
  value = module.talos_cluster_nodes.nodes
}
