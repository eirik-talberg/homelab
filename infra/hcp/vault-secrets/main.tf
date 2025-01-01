terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.99.0"
    }
  }
}

variable "project_id" {
  type        = string
  default     = "320c9a8d-83a9-4d69-8d6f-cc5174d8bf48"
  description = "HCP Project ID"
}

variable "iac_service_principal_name" {
  type    = string
  default = "sp-taldev-iac"
}


provider "hcp" {
  project_id = var.project_id
}

resource "hcp_vault_secrets_app" "cluster_infra_core" {
  app_name    = "cluster-infra-core"
  description = "Core secrets storage for Taldev"
}

data "hcp_service_principal" "sp" {
  resource_name = "iam/project/${var.project_id}/service-principal/${var.iac_service_principal_name}"
}

resource "hcp_vault_secrets_app_iam_binding" "sp_iam_binding" {
  resource_name = hcp_vault_secrets_app.cluster_infra_core.resource_name
  principal_id  = data.hcp_service_principal.sp.resource_id
  role          = "roles/secrets.app-secret-reader"
}

resource "hcp_vault_secrets_app" "letsencrypt_taldev" {
  app_name    = "letsencrypt-taldev"
  description = "Secrets for managing certificates with Let's Encrypt (ACME)"
}

resource "hcp_vault_secrets_app_iam_binding" "sp_iam_binding_letsencrypt_taldev" {
  resource_name = hcp_vault_secrets_app.letsencrypt_taldev.resource_name
  principal_id  = data.hcp_service_principal.sp.resource_id
  role          = "roles/secrets.app-secret-reader"
}
