# Terraform Block
terraform {
  # required_version = "~>=1.1.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }

  backend "s3" {
    bucket  = "demo-terraform-tfstate"
    key     = "remote-tfstate"
    region  = "us-west-2"
    profile = "dva-c01"
  }
}