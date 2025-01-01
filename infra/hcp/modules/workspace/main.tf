terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.60.1"
    }
  }
}

variable "organization" {
  type = string
}

variable "project_name" {
  type = string
}

variable "workspace_name" {
  type = string
}

provider "tfe" {
  organization = var.organization
}

data "tfe_organization" "this" {
  name = var.organization
}

data "tfe_project" "this" {
  name         = var.project_name
  organization = data.tfe_organization.this.name
}

resource "tfe_workspace" "this" {
  name         = var.workspace_name
  organization = data.tfe_organization.this.name
  project_id   = data.tfe_project.this.id
}
