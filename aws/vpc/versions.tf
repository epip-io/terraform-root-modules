terraform {
  required_version = "~> 0.12"

  required_providers {
    aws = "~> 2.43"
  }

  # If using Terragrunt, this will be replaced with the correct configuration
  backend "s3" {}
}