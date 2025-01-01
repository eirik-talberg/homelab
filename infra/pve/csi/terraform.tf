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
      name = "pve-csi"
      #prefix = "pve-csi"
    }
  }
}
