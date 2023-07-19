resource "opensearch_index_template" "testing" {
  name     = "testing"
  body     = <<EOF
{
  "template" : "index_t*",
  "settings": {
    "codec"                                = "best_compression"
    "number_of_replicas"                   = 1
    "number_of_shards"                     = 5
    "search_slowlog_threshold_query_debug" = "30s"
    "search_slowlog_threshold_query_info"  = "15s"
    "search_slowlog_threshold_query_trace" = "10s"
    "search_slowlog_threshold_query_warn"  = "5s"
   },
   "mappings": {

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

