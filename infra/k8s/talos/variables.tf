variable "controllers" {
  type = object({
    count     = number
    cpu_cores = number
    memory    = number
    disk_size = number
  })
}

variable "workers" {
  type = object({
    count     = number
    cpu_cores = number
    memory    = number
    disk_size = number
  })
}

variable "cluster_label" {
  type = string
}

variable "talos_version" {
  type = string
}

variable "kubeconfig_folder" {
  type = string
}

variable "metallb_version" {
  type = string
}

variable "ip_range" {
  type = string

}
