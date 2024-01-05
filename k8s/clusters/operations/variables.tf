locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "operations"
  pve_hostname   = "pve"
  target_node    = "pve-prod-01"
  nodes          = {
    "master" = {
      "k3s-ops-01" = {
        vm_id    = 161
        template = "ubuntu-2204-medium"
      },
      "k3s-ops-02" = {
        vm_id    = 162
        template = "ubuntu-2204-medium"
      },
      "k3s-ops-03" = {
        vm_id    = 163
        template = "ubuntu-2204-medium"
      }
    },
    "agent" = {
      "k3s-ops-04" = {
        vm_id    = 164
        template = "ubuntu-2204-large"
      },
      "k3s-ops-05" = {
        vm_id    = 165
        template = "ubuntu-2204-large"

      },
      "k3s-ops-06" = {
        vm_id    = 166
        template = "ubuntu-2204-large"
      }
    }
  }
}