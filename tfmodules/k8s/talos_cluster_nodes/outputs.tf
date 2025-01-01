output "nodes" {
  value = local.nodes
}

output "talosconfig" {
  value     = data.talos_client_configuration.this.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive = true
}

output "cluster_name" {
  value = "tls-${var.cluster_label}"
}

output "kubeconfig_location" {
  value = "${pathexpand(var.kubeconfig_location)}/${local.cluster_name}"
}
