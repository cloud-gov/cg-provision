terraform {
  backend "s3" {
  }
}

provider "aws" {
  use_fips_endpoint = true
  default_tags {
    tags = {
      deployment = "terraform-state-bucket"
      environment = "common"
      provisioner = "terraform"
    }
  }
}

data "aws_partition" "current" {
}