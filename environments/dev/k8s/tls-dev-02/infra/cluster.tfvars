cluster_label     = "dev-02"
talos_version     = "1.8.2"
kubeconfig_folder = "~/.kube"
metallb_version   = "0.14.9"
ip_range          = "10.0.69.250-10.0.69.251"
controllers = {
  count     = 1
  cpu_cores = 4
  memory    = 4096
  disk_size = 32
}
workers = {
  count     = 1
  cpu_cores = 4
  memory    = 4096
  disk_size = 32
}
