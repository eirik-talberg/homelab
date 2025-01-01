terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.99.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.69.0"
    }
  }
}
