terraform {
  required_version = ">= 0.15"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "< 6.0.0"
    }
    elasticsearch = {
      source = "phillbaker/elasticsearch"
      version = "2.0.7"
    }
  }
}
