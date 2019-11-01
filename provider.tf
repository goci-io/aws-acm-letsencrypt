terraform {
  required_version = ">= 0.12.1"
}

locals {
  acme_directory = contains(["prod", "production", "main"], var.stage) ? "acme-v02" : "acme-staging-v02"
}

provider "acme" {
  version    = "~> 1.5"
  server_url = "https://${local.acme_directory}.api.letsencrypt.org/directory"
}

provider "aws" {
  version = "~> 2.25"
  region  = var.aws_region
}
