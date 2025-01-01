terraform {
  required_providers {
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.1.0"
    }
  }
}

provider "argocd" {
  username                    = var.username
  password                    = var.password
  port_forward_with_namespace = var.namespace
}

resource "argocd_application" "cluster_infra" {
  metadata {
    name      = "cluster-infra"
    namespace = var.namespace
    labels = {
      "managed-by" : "terraform"
    }
  }
  spec {
    destination {
      namespace = "cluster-infra"
      server    = "https://kubernetes.default.svc"
    }
    project = "default"
    source {
      repo_url        = "https://github.com/eirik-talberg/homelab"
      path            = "k8s/apps/talos-cluster-infra"
      target_revision = var.cluster_infra_revision
      helm {
        values = yamlencode({
          metallb = {
            enabled = false
          }
        })
      }
    }
    sync_policy {
      automated {

      }
    }
  }

}

