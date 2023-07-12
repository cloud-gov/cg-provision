
terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 6.0.0"
    }
    opensearch = {
      source  = "github.com:serge-r/terraform-provider-opensearch.git"
    }
  }
}
