# Configure the Opensearch provider
provider "opensearch" {
  url = "localhost:9200"
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