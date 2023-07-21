resource "opensearch_index_template" "app_logs_template" {
  name     = "app_logs_template"
  body     = <<EOF
{
	"template": "logs-app*",
	"settings": {
		"codec": "best_compression",
		"number_of_replicas": 1,
		"number_of_shards": 5,
		"search": {
			"slowlog": {
				"threshold": {
					"query": {
						"warn": "30s",
						"info": "15s",
						"debug": "10s",
						"trace": "5s"
					}
				}
			}
		}
	},
	"mappings": {
		"dynamic_templates": [{
			"string_fields": {
				"match": "*",
				"match_mapping_type": "string",
				"mapping": {
					"type": "keyword",
					"index": true,
					"norms": false
				}
			}
		}],
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

resource "opensearch_dashboard_object" "logs_app_index_pattern" {
  body = <<EOF
[
  {
    "_id": "index-pattern:logs-app",
    "_type": "doc",
    "_source": {
      "type": "index-pattern",
      "index-pattern": {
        "title": "logs-app-*",
        "timeFieldName": "timestamp"
      }
    }
  }
]
EOF
}
