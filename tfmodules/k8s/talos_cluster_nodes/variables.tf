variable "controllers" {
  type = object({
    count     = number
    cpu_cores = number
    memory    = number
    disk_size = number
  })
  default = {
    count     = 3
    cpu_cores = 2
    memory    = 2048
    disk_size = 8
  }
}

variable "workers" {
  type = object({
    count     = number,
    cpu_cores = number
    memory    = number
    disk_size = number
  })
  default = {
    count     = 3
    cpu_cores = 4
    memory    = 4096
    disk_size = 16
  }
}

variable "talos_version" {
  type = string
}

variable "cluster_label" {
  type = string
}

variable "metallb_version" {
  type = string
}

variable "ip_range" {
  type = string
}

variable "talos_config_location" {
  type    = string
  default = "~/.talos"
}

variable "kubeconfig_location" {
  type    = string
  default = "~/.kube"
}

variable "pve_cluster_name" {
  type    = string
  default = "taldev-01"
}

variable "pve_node_name" {
  type    = string
  default = "pve-prod-01"
}
