cluster_label     = "dev-01"
talos_version     = "1.9.0"
kubeconfig_folder = "~/.kube"
controllers = {
  count     = 1
  cpu_cores = 6
  memory    = 8192
  disk_size = 32
}
workers = {
  count     = 0
  cpu_cores = 0
  memory    = 0
  disk_size = 0
}
