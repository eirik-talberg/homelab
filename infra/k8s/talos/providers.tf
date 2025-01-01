provider "proxmox" {
  # Configuration options
  endpoint = "https://pve.taldev.no"

  ssh {
    agent       = false
    username    = "root"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
}

provider "talos" {}
