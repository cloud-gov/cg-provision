# Configure the Opensearch provider
provider "opensearch" {
  url = aws_opensearch_domain.opensearch.endpoint
  username = var.master_user_name
  password = var.master_user_password
}

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = var.domain_name
  engine_version = var.engine

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_name     = var.master_user_name
      master_user_password = var.master_user_password
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 15
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  cluster_config {
    instance_type            = var.instance_type
    dedicated_master_count   = var.dedicated_master_count
    dedicated_master_enabled = var.dedicated_master_enabled
    dedicated_master_type    = var.dedicated_master_type
    instance_count           = var.instance_count
    zone_awareness_enabled   = true
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  vpc_options {
    subnet_ids = var.private_elb_subnets
  }
}

resource "opensearch_index" "test" {
  name               = "terraform-test"
  number_of_shards   = 1
  number_of_replicas = 1
  mappings           = <<EOF
{
  "people": {
    "_all": {
      "enabled": false
    },
    "properties": {
      "email": {
        "type": "text"
      }
    }
  }
}
EOF
}

resource "opensearch_component_template" "test" {
  name = "terraform-test"
  body = <<EOF
{
  "template": {
    "settings": {
      "index": {
        "number_of_shards": 1
      }
    },
    "mappings": {
      "properties": {
        "host_name": {
          "type": "keyword"
        },
        "created_at": {
          "type": "date",
          "format": "EEE MMM dd HH:mm:ss Z yyyy"
        }
      }
    },
    "aliases": {
      "mydata": { }
    }
  }
}
EOF
}