cluster_label     = "dev-tls-01"
talos_version     = "1.9.1"
kubeconfig_folder = "~/.kube"
controllers = {
  count     = 1
  cpu_cores = 4
  memory    = 4096
  disk_size = 32
}
workers = {
  count     = 3
  cpu_cores = 4
  memory    = 4096
  disk_size = 32
}
metallb_version = "0.14.9"
ip_range        = "10.0.69.30-10.0.69.35"
