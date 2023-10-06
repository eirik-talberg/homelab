locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "sandbox"
  nodes          = {
    "master" = {
      "k3s-sbx-01" = {
        vm_id        = 151
        cores        = 2
        memory       = 4096
        os_disk      = {}
        storage_disk = {}
      },
      "k3s-sbx-02" = {
        vm_id        = 152
        cores        = 2
        memory       = 4096
        os_disk      = {}
        storage_disk = {}
      },
      "k3s-sbx-03" = {
        vm_id        = 153
        cores        = 2
        memory       = 4096
        os_disk      = {}
        storage_disk = {}
      }
    },
    "agent" = {}
  }
}