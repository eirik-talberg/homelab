locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "prod"
  pve_hostname   = "pve"
  target_node    = "pve-prod-01"
  nodes          = {
    "master" = {
      "k3s-prod-01" = {
        vm_id    = 171
        template = "ubuntu-2204-medium"
      },
      "k3s-prod-02" = {
        vm_id    = 172
        template = "ubuntu-2204-medium"
      },
      "k3s-prod-03" = {
        vm_id    = 173
        template = "ubuntu-2204-medium"
      }
    },
    "agent" = {
      "k3s-prod-04" = {
        vm_id    = 174
        template = "ubuntu-2204-large"
      },
      "k3s-prod-05" = {
        vm_id    = 175
        template = "ubuntu-2204-large"

      },
      "k3s-prod-06" = {
        vm_id    = 176
        template = "ubuntu-2204-large"
      }
    }
  }
}