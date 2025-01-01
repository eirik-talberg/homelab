variable "cpu_cores" {
  type        = number
  default     = 2
  description = "Number of CPU cores"
}

variable "cpu_type" {
  type    = string
  default = "x86-64-v2-AES"
}

variable "memory" {
  type    = number
  default = 2048
}

variable "datastore_id" {
  type    = string
  default = "vm-storage"
}

variable "os" {
  type        = string
  default     = "l26"
  description = "Type of OS to create"
}

variable "name" {
  type        = string
  description = "Name of node"
}

variable "tags" {
  type        = list(string)
  default     = []
  description = "Additinoal tags to apply to the node"

}

variable "id" {
  type        = number
  description = "(Optional) VM ID"
  default     = null
}

variable "image_id" {
  type        = string
  description = "Image id on the given datastore to restore from"
}

variable "disk_size" {
  type    = number
  default = 8
}

variable "pve_node" {
  type    = string
  default = "pve-prod-01"
}

variable "pve_node_network_interface_id" {
  type    = number
  default = 7
}
