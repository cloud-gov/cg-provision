resource "opensearch_index_template" "index_template" {
  name     = "index_template"
  body     = <<EOF
{
  "template" : "index_t*",
  "settings": {
  "number_of_shards": 1
   }
  }
}
EOF
}