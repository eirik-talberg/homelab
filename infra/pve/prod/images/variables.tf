variable "files" {
  type = list(object({
    name         = string
    datastore_id = string
    content_type = string
    file_name    = string
    url          = string
  }))
}

variable "node_name" {
  type    = string
  default = "pve-prod-01"
}

