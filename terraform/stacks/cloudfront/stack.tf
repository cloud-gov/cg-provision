terraform {
  backend "s3" {
  }
}

provider "aws" {
  access_key        = var.aws_access_key
  secret_key        = var.aws_secret_key
  region            = var.aws_region
  use_fips_endpoint = true

  default_tags {
    tags = {
      deployment = "cloudfront-${var.stack_description}"
      stack      = "${var.stack_description}"
    }
  }
}

data "terraform_remote_state" "govcloud" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket
    region = var.remote_state_region
    key    = "${var.stack_description}/terraform.tfstate"
  }
}
