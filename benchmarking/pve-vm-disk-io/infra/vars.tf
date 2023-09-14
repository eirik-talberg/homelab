variable "pve_user" {
  type = string
}

variable "pve_host" {
  type = string
}

variable "node_user" {
  type = string
}

variable "node_gecos" {
  type = string
}

variable "gateway" {
  type = string
}

variable "subnet" {
  type = string
}

variable "template_name" {
  type = string
}

variable "target_node" {
  type = string
}

variable "storage_pool" {
  type = string
}

variable "nodes" {
  default = {
    "disk-bench-test-2g" = {
      vm_id = 100
      cores = 4
      sockets = 1
      memory = 2048
      os_disk = {
        type = "scsi"
        size = "32G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
      storage_disk = {
        type = "scsi"
        size = "64G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
    },
    "disk-bench-test-4g" = {
      vm_id = 101
      cores = 4
      sockets = 1
      memory = 4096
      os_disk = {
        type = "scsi"
        size = "32G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
      storage_disk = {
        type = "scsi"
        size = "64G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
    }
    "disk-bench-test-8g" = {
      vm_id = 102
      cores = 4
      sockets = 1
      memory = 8192
      os_disk = {
        type = "scsi"
        size = "32G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
      storage_disk = {
        type = "scsi"
        size = "64G"
        iothread = 1
        ssd = 1
        discard = "on"
      }
    }
  }
}