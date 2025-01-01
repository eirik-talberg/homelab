variable "argocd_version" {
  type = string
}

variable "hcp_project_id" {
  type = string
}

variable "hcp_service_principal" {
  type = string
}

variable "kubeconfig_folder" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "argocd_namespace" {
  type = string
}

variable "pve_url" {
  type    = string
  default = "https://pve.taldev.no"
}

variable "pve_cluster_name" {
  type    = string
  default = "taldev-01"
}
