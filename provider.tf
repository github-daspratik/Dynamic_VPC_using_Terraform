# Provider Block
provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}
/*
provider "aws" {
  profile = var.aws_profile
  region  = "us-west-1"
  alias   = "california"
}
*/