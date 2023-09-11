locals {
  sql_in_directory  = "${path.root}/sql"
  sqlTemplateInput  = fileset(local.sql_in_directory, "*.sql.tftpl")
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "aggregations"
  location                    = var.gcp.region
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "view-dataproduct" {
  for_each = local.sqlTemplateInput

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "view-dataproduct-${split(".", each.key)[0]}"
  view {
    query = templatefile("${local.sql_in_directory}/${each.key}", {
      source_table = var.input.source_table
    })
    use_legacy_sql = false
  }
}
