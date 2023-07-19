resource "opensearch_index_template" "index_template" {
  name     = "index_template"
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
  number_of_shards                     = 1
  number_of_replicas                   = 1
  search_slowlog_threshold_query_debug = "30s"
  search_slowlog_threshold_query_info  = "15s"
  search_slowlog_threshold_query_trace = "10s"
  search_slowlog_threshold_query_warn  = "5s"
  mappings     = <<EOF
{
}
EOF
}

