terraform {
  required_version = ">= 0.12.1"

  required_providers {
    tls = "~> 2.1"
  }
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

  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}
