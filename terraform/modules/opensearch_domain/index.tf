resource "opensearch_index_template" "index_template" {
  name     = "test_index"
  body     = <<EOF
{
  "template" : "test2",
  "settings": {
  "number_of_shards": 1
   },
   "mappings": {
    "type1": {
      "properties": {
        "created_at": {
          "type": "date",
          "format": "EEE MMM dd HH:mm:ss Z YYYY"
        }
      }
    }
  }
}
EOF
}