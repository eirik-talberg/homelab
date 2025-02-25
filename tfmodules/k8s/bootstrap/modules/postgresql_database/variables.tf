variable "hcp_project_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "port" {
  type    = number
  default = 5432
}

variable "database" {
  type    = string
  default = "postgres"
}

variable "ssl_mode" {
  type    = string
  default = "disable"
}

variable "app_name" {
  type = string
}
