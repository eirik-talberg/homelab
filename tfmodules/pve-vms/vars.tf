variable "pve_user" {
  description = "Login username for you Proxmox VE environment"
  type        = string
  default     = "root"
}

variable "domain" {
  description = "Domain name for hosts"
  type        = string
  default     = "taldev.no"
}

variable "pve_hostname" {
  description = "Hostname for PVE cluster"
  type        = string
  default     = "pve"
}

variable "pve_node" {
  description = "PVE node for SSH login"
  type        = string
  default     = "pve-01"
}

variable "node_user" {
  description = "VM node username"
  type        = string
  default     = "taldev"
}

variable "node_gecos" {
  description = "VM node GECOS information"
  type        = string
  default     = "taldev"
}

variable "gateway" {
  description = "Gateway IP for you network configuration"
  type        = string
  default     = "10.0.69.1"
}

variable "subnet" {
  description = "Subnet for the VM nodes"
  type        = string
  default     = "10.0.69"
}

variable "template_name" {
  description = "Name of the VM template to use"
  type        = string
  default     = "ubuntu-2204-cloud-init"
}

variable "install_packages" {
  description = "Packages to install in Cloud Init"
  type        = list(string)
  default     = []
}

variable "target_node" {
  description = "Proxmox VE node to target"
  type        = string
  default     = "pve-01"
}

variable "storage_pool" {
  description = "Storage pool in Proxmox VE for VM storage"
  type        = string
  default     = "vm-storage"
}

variable "nodes" {
  type = map(object({
    vm_id    = optional(number, 0),
    template = string
  }))
}