locals {
  image_id = "local-btrfs:iso/talos-${var.talos_version}.img"
}

module "controllers" {
  source    = "../../pve/vm"
  count     = var.controllers.count
  name      = "${var.cluster_label}-ctr-${format("%02s", count.index + 1)}"
  cpu_cores = var.controllers.cpu_cores
  memory    = var.controllers.memory
  disk_size = var.controllers.disk_size
  image_id  = local.image_id
  tags      = [var.cluster_label, "talos"]
}

module "workers" {
  source    = "../../pve/vm"
  count     = var.workers.count
  name      = "${var.cluster_label}-wrk-${format("%02s", count.index + 1)}"
  cpu_cores = var.workers.cpu_cores
  memory    = var.workers.memory
  disk_size = var.workers.disk_size
  image_id  = local.image_id
  tags      = [var.cluster_label, "talos"]
}

locals {
  nodes = {
    "controllers" = { for controller in module.controllers :
      controller.name => {
        ipv4_address = controller.ipv4_address
      }
    }
    "workers" : { for worker in module.workers :
      worker.name => {
        ipv4_address = worker.ipv4_address
      }
    }
  }
  cluster_endpoint = "https://${module.controllers.0.ipv4_address}:6443"
  cluster_name     = var.cluster_label
}

resource "talos_machine_secrets" "this" {
  talos_version = "v${var.talos_version}"
}


data "talos_machine_configuration" "controller" {
  cluster_name     = local.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  docs             = true
}

data "talos_machine_configuration" "worker" {
  cluster_name     = local.cluster_name
  machine_type     = "worker"
  cluster_endpoint = local.cluster_endpoint
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  docs             = true

}

data "talos_client_configuration" "this" {
  cluster_name         = local.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in local.nodes.controllers : v.ipv4_address]
}

resource "talos_machine_configuration_apply" "controller" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controller.machine_configuration
  for_each                    = local.nodes.controllers
  node                        = each.value.ipv4_address
  config_patches = [
    yamlencode({
      cluster = {
        extraManifests = [
          "https://raw.githubusercontent.com/metallb/metallb/v${var.metallb_version}/config/manifests/metallb-native.yaml"
        ],
        inlineManifests = [{
          name = "metallb-crds",
          contents = templatefile("${path.module}/metallb_crds.yaml.tftpl", {
            ip_range = var.ip_range
          })
        }]
      }
    }),
    yamlencode({
      machine = {
        network = {
          hostname = each.key
        }
        nodeLabels = {
          "topology.kubernetes.io/region" = var.pve_cluster_name
          "topology.kubernetes.io/zone"   = var.pve_node_name
        }
      }
      /*
      cluster = {
        allowSchedulingOnControlPlanes = (length(local.nodes.workers) == 0)
        proxy = {
          mode = "ipvs"
          extraArgs = {
            ipvs-strict-arp = true
          }
        }
      }
      */
    })
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = local.nodes.workers
  node                        = each.value.ipv4_address
  config_patches = [
    yamlencode({
      machine = {
        network = {
          hostname = each.key
        }
        nodeLabels = {
          "topology.kubernetes.io/region" = var.pve_cluster_name
          "topology.kubernetes.io/zone"   = var.pve_node_name
        }
      }
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controller]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in local.nodes.controllers : v][0].ipv4_address
}

data "talos_cluster_health" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  control_plane_nodes  = [for k, v in local.nodes.controllers : v.ipv4_address]
  endpoints            = [for k, v in local.nodes.controllers : v.ipv4_address]
  worker_nodes         = [for k, v in local.nodes.workers : v.ipv4_address]
  depends_on           = [talos_machine_bootstrap.this]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in local.nodes.controllers : v][0].ipv4_address
}

resource "local_file" "talos_config" {
  filename = "${pathexpand(var.talos_config_location)}/${var.cluster_label}"
  content  = data.talos_client_configuration.this.talos_config
}

resource "local_file" "kubeconfig" {
  filename = "${pathexpand(var.kubeconfig_location)}/${local.cluster_name}"
  content  = talos_cluster_kubeconfig.this.kubeconfig_raw
}
