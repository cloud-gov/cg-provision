resource "opensearch_index_template" "logs-app-*" {
  name     = testing
  body     = <<EOF
{
  "template" : "index_t*",
  "settings": {
  "number_of_shards": 1
   }
}
EOF
}

resource "opensearch_index" "index" {
  name                                 = "index"
  codec                                = "best_compression"
  number_of_replicas                   = 1
  number_of_shards                     = 5
  search_slowlog_threshold_query_debug = "30s"
  search_slowlog_threshold_query_info  = "15s"
  search_slowlog_threshold_query_trace = "10s"
  search_slowlog_threshold_query_warn  = "5s"
  mappings     = <<EOF
{
    "dynamic_templates": [
    {
        "string_fields": {
        "match": "*",
        "match_mapping_type": "string",
        "mapping": {
            "type": "keyword",
            "index": true,
            "norms": false
        }
        }
    }
    ],
    "properties": {
        "@version": {
            "type": "keyword",
            "index": true
            },
        "@raw": {
            "type": "text",
            "index": true,
            "norms": false
            },
        "geoip": {
            "type": "object",
            "dynamic": true,
            "properties": {
                "location": {
                    "type": "geo_point"
                    }
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

resource "opensearch_composable_index_template" "template_1" {
  name = "template_1"
  body = <<EOF
{
    "index_patterns": ["testing*"],
    "composed_of": [
        "terraform-test"
    ],
    "priority": 202
}
EOF
}

