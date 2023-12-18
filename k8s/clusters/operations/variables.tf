locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "operations"
  nodes          = {
    "master" = {
      "k3s-ops-01" = {
        vm_id   = 161
        cores   = 8
        memory  = 8192
        os_disk = {
            size = "32G"
        }
      },
    },
    "agent" = {
    }
  }
}