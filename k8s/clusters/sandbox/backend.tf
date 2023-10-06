terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "taldev"

    workspaces {
      name = "k3s-sandbox"
    }
  }
}