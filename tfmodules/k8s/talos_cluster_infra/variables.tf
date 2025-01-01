variable "cluster_infra_revision" {
  type        = string
  description = "Git revision to fetch Helm Chart from"
  default     = "HEAD"
}

variable "cluster_infra_values" {
  type        = string
  description = "Path to values-file to pass to the ArgoCD Helm installation"
  default     = "argo-cd-values.yaml"
}

variable "username" {
  type        = string
  default     = "admin"
  description = "Login username for ArgoCD API"
  sensitive   = true
}

variable "password" {
  type        = string
  default     = ""
  description = "Login password for ArgoCD API"
  sensitive   = true
}

variable "namespace" {
  type        = string
  default     = "argo-cd"
  description = "Namespace where ArgoCD is installed in the cluster"
}
