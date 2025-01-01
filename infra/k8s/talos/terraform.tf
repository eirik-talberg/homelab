terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.66.3"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "0.7.0-alpha.0"
    }
  }
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "taldev"

    workspaces {
      prefix = "infra-k8s-talos-"
      #name = "talos-dev-01"
    }
  }
}
