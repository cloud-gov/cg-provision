resource "opensearch_index_template" "app_logs_template" {
  name     = "app_logs_template"
  body     = <<EOF
{
	"index_patterns": ["logs-app-*"],
	"template": "index_t*",
	"priority": 202,
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
			"tags": {
				"type": "keyword",
				"index": true
			},
			"@input": {
				"type": "keyword",
				"index": true
			},
			"@index_type": {
				"type": "keyword",
				"index": true
			},
			"@type": {
				"type": "keyword",
				"index": true
			},
			"@timestamp": {
				"type": "date"
			},
			"@message": {
				"type": "text",
				"index": true,
				"norms": false,
				"fields": {
					"raw": {
						"type": "keyword",
						"index": true,
						"ignore_above": 256
					}
				}
			},
			"@level": {
				"type": "keyword",
				"index": true
			},
			"@shipper": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"name": {
						"type": "keyword",
						"index": true
					},
					"priority": {
						"type": "long"
					}
				}
			},
			"@source": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"deployment": {
						"type": "keyword",
						"index": true
					},
					"host": {
						"type": "keyword",
						"index": true
					},
					"job": {
						"type": "keyword",
						"index": true
					},
					"job_index": {
						"type": "keyword",
						"index": true
					},
					"index": {
						"type": "long"
					},
					"component": {
						"type": "keyword",
						"index": true
					},
					"type": {
						"type": "keyword",
						"index": true
					},
					"vm": {
						"type": "keyword",
						"index": true
					}
				}
			},
			"@cf": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"app": {
						"type": "keyword",
						"index": true
					},
					"app_id": {
						"type": "keyword",
						"index": true
					},
					"app_instance": {
						"type": "long"
					},
					"org": {
						"type": "keyword",
						"index": true
					},
					"org_id": {
						"type": "keyword",
						"index": true
					},
					"space": {
						"type": "keyword",
						"index": true
					},
					"space_id": {
						"type": "keyword",
						"index": true
					}
				}
			},
			"logmessage": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"message_type": {
						"type": "keyword",
						"index": true
					}
				}
			},
			"rtr": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"response_time_ms": {
						"type": "long"
					},
					"remote_addr": {
						"type": "keyword",
						"index": true
					},
					"x_forwarded_proto": {
						"type": "keyword",
						"index": true
					},
					"x_forwarded_for": {
						"type": "keyword",
						"index": true
					},
					"vcap_request_id": {
						"type": "keyword",
						"index": true
					},
					"body_bytes_sent": {
						"type": "long"
					},
					"hostname": {
						"type": "keyword",
						"index": true
					},
					"timestamp": {
						"type": "keyword",
						"index": true
					},
					"request_bytes_received": {
						"type": "long"
					},
					"verb": {
						"type": "keyword",
						"index": true
					},
					"path": {
						"type": "keyword",
						"index": true
					},
					"http_spec": {
						"type": "keyword",
						"index": true
					},
					"referer": {
						"type": "keyword",
						"index": true
					},
					"http_user_agent": {
						"type": "keyword",
						"index": true
					},
					"status": {
						"type": "long"
					},
					"src": {
						"type": "object",
						"dynamic": true,
						"properties": {
							"host": {
								"type": "keyword",
								"index": true
							},
							"port": {
								"type": "long"
							}
						}
					},
					"dst": {
						"type": "object",
						"dynamic": true,
						"properties": {
							"host": {
								"type": "keyword",
								"index": true
							},
							"port": {
								"type": "long"
							}
						}
					},
					"app": {
						"type": "object",
						"dynamic": true,
						"properties": {
							"id": {
								"type": "keyword",
								"index": true
							},
							"index": {
								"type": "long"
							}
						}
					}
				}
			},
			"geoip": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"location": {
						"type": "geo_point"
					},
					"timezone": {
						"type": "keyword",
						"index": true
					}
				}
			},
			"containermetric": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"memory_bytes_quota": {
						"type": "long"
					},
					"memory_bytes": {
						"type": "long"
					},
					"disk_bytes_quota": {
						"type": "long"
					},
					"disk_bytes": {
						"type": "long"
					},
					"cpu_percentage": {
						"type": "scaled_float",
						"scaling_factor": 100
					}
				}
			},
			"valuemetric": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"unit": {
						"type": "keyword",
						"index": true
					},
					"name": {
						"type": "keyword",
						"index": true
					},
					"value": {
						"type": "long"
					}
				}
			},
			"counterevent": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"delta": {
						"type": "long"
					},
					"name": {
						"type": "keyword",
						"index": true
					},
					"total": {
						"type": "long"
					}
				}
			},
			"error": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"source": {
						"type": "keyword",
						"index": true
					},
					"code": {
						"type": "long"
					}
				}
			},
			"httpstartstop": {
				"type": "object",
				"dynamic": true,
				"properties": {
					"stop_timestamp": {
						"type": "long"
					},
					"request_id": {
						"type": "keyword",
						"index": true
					},
					"peer_type": {
						"type": "keyword",
						"index": true
					},
					"method": {
						"type": "keyword",
						"index": true
					},
					"uri": {
						"type": "keyword",
						"index": true
					},
					"remote_addr": {
						"type": "keyword",
						"index": true
					},
					"user_agent": {
						"type": "keyword",
						"index": true
					},
					"status_code": {
						"type": "long"
					},
					"content_length": {
						"type": "long"
					},
					"instance_index": {
						"type": "long"
					},
					"instance_id": {
						"type": "keyword",
						"index": true
					},
					"forwarded": {
						"type": "keyword",
						"index": true
					},
					"duration_ms": {
						"type": "long"
					}
				}
			},
			"@version": {
				"type": "keyword",
				"index": true
			},
			"@raw": {
				"type": "text",
				"index": true,
				"norms": false
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
