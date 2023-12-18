locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "sandbox"
  nodes          = {
    "master" = {
      "k3s-sbx-01" = {
        vm_id   = 151
        cores   = 2
        memory  = 2048
        os_disk = {}
      },
    },
    "agent" = {
      "k3s-sbx-02" = {
        vm_id   = 152
        cores   = 2
        memory  = 4096
        os_disk = {
          size = "32G"
        }
      },
      "k3s-sbx-03" = {
        vm_id   = 153
        cores   = 2
        memory  = 4096
        os_disk = {
          size = "32G"
        }
      },
      "k3s-sbx-04" = {
        vm_id   = 154
        cores   = 2
        memory  = 4096
        os_disk = {
          size = "32G"
        }
      }
    }
  }
}