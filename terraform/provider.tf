terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
  cloud {

    organization = "nyah-core"

    workspaces {
      name = "platform-de-do"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
