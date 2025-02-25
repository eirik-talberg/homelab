terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.99.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }

}
