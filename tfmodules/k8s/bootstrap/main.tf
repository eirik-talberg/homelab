resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = var.argocd_version
  chart            = "argo-cd"
  atomic           = true
  namespace        = var.argocd_namespace
  create_namespace = "true"
  values = [
    yamlencode({
      config = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]
}

resource "kubernetes_namespace" "cluster_infra" {
  metadata {
    name = "cluster-infra"
    labels = {
      managed-by = "terraform"
    }
  }
}

data "hcp_organization" "taldev" {}

data "hcp_project" "homelab" {
  project = "320c9a8d-83a9-4d69-8d6f-cc5174d8bf48"
}

resource "hcp_service_principal" "service_principal" {
  name   = "${var.cluster_name}-sp"
  parent = data.hcp_project.homelab.resource_name
}
data "hcp_vault_secrets_app" "cluster_infra_core" {
  app_name = "cluster-infra-core"
}

resource "hcp_service_principal_key" "key" {
  service_principal = hcp_service_principal.service_principal.resource_name
}

resource "hcp_vault_secrets_app_iam_binding" "sp_iam_binding" {
  resource_name = "secrets/project/${var.hcp_project_id}/app/${data.hcp_vault_secrets_app.cluster_infra_core.id}"
  principal_id  = hcp_service_principal.service_principal.resource_id
  role          = "roles/secrets.app-secret-reader"
}

data "hcp_vault_secrets_secret" "letsencrypt_account_key" {
  app_name    = "letsencrypt-taldev"
  secret_name = "letsencrypt_account_key"
}

resource "kubernetes_secret" "letsencrypt_account_key" {
  metadata {
    name      = "letsencrypt-account-key"
    namespace = "cluster-infra"
  }
  depends_on = [
    kubernetes_namespace.cluster_infra
  ]

  data = {
    "tls.key" : base64decode(data.hcp_vault_secrets_secret.letsencrypt_account_key.secret_value)
  }
}

resource "kubernetes_secret" "hcp_service_principal_credentials" {
  metadata {
    name      = "hcp-service-principal-credentials"
    namespace = "cluster-infra"
  }
  depends_on = [
    kubernetes_namespace.cluster_infra
  ]
  data = {
    "clientID"     = hcp_service_principal_key.key.client_id
    "clientSecret" = hcp_service_principal_key.key.client_secret
  }
}

data "proxmox_virtual_environment_user" "csi_token_user" {
  user_id = "kubernetes-csi@pve"
}

resource "proxmox_virtual_environment_user_token" "csi_token" {
  comment               = "Managed by Terraform"
  expiration_date       = "2033-01-01T22:00:00Z"
  token_name            = "csi-token-${var.cluster_name}"
  user_id               = data.proxmox_virtual_environment_user.csi_token_user.user_id
  privileges_separation = false
}

resource "kubernetes_secret" "proxmox_csi_config" {
  metadata {
    name      = "proxmox-csi-plugin"
    namespace = "csi-proxmox"
  }
  type       = "generic"
  depends_on = [proxmox_virtual_environment_user_token.csi_token]
  data = {
    "config.yaml" = templatefile("proxmox-csi-config.yaml.tftpl", {
      pve_url          = "${var.pve_url}/api2/json"
      token_id         = proxmox_virtual_environment_user_token.csi_token.id
      token_secret     = split("=", proxmox_virtual_environment_user_token.csi_token.value).1
      pve_cluster_name = "taldev-01"
    })
  }
}
