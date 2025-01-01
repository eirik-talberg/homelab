provider "helm" {
  kubernetes {
    config_path = "${var.kubeconfig_folder}/${var.cluster_name}"
  }
}

provider "kubernetes" {
  config_path = "${var.kubeconfig_folder}/${var.cluster_name}"
}

provider "hcp" {
  project_id = var.hcp_project_id
}

provider "proxmox" {
  endpoint = "https://pve.taldev.no"

  ssh {
    agent       = false
    username    = "root"
    private_key = file(pathexpand("~/.ssh/id_rsa"))
  }
}
