locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "sandbox"
  pve_hostname   = "pve-sbx"
  target_node    = "pve-sbx-01"
  nodes          = {
    "master" = {
      "k3s-sbx-01" = {
        vm_id    = 151
        template = "ubuntu-2204-medium"
      },
    },
    "agent" = {
      "k3s-sbx-02" = {
        vm_id    = 152
        template = "ubuntu-2204-medium"
      },
      "k3s-sbx-03" = {
        vm_id    = 153
        template = "ubuntu-2204-medium"
      },
      "k3s-sbx-04" = {
        vm_id    = 154
        template = "ubuntu-2204-medium"
      }
    }
  }
}