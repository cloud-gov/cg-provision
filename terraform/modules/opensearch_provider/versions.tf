terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 6.0.0"
    }
    opensearch = {
     source = "https://github.com/opensearch-project/terraform-provider-opensearch.git"
     version = "1.0.0"
    }
  }
}
