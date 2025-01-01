terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.3"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "taldev"

    workspaces {
      name = "infra-pve-prod-images"
    }
  }
}

resource "proxmox_virtual_environment_download_file" "image" {
  for_each     = variable.files
  content_type = each.value.content_type
  datastore_id = each.value.datastore_id
  node_name    = variable.node
  file_name    = each.value.file_name
  url          = each.value.url
}

