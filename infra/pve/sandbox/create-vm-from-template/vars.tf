locals {
  domain         = "taldev.no"
  subnet         = "10.0.69"
  inventory_name = "sandbox"
  pve_hostname   = "pve-sbx"
  target_node    = "pve-sbx-01"
  nodes          = {
    "ubuntu-template-test" = {
      vm_id    = 101
      template = "ubuntu-2204-small"

    }
  }
}