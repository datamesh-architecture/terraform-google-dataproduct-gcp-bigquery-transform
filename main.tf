provider "google" {
  project = var.gcp.project
  region  = var.gcp.region
}

locals {
  sql_in_directory    = "${path.root}/sql"
  sql_out_directory   = "${path.root}/out_sql"
  sqlTemplateInput    = fileset("${local.sql_in_directory}", "*.sql.tftpl")
  sqlFiles            = fileset("${local.sql_out_directory}", "*.sql")
}

resource "local_file" "transform_sql" {
  for_each = local.sqlTemplateInput

  content = templatefile("${local.sql_in_directory}/${each.key}", {
      source_table = "${var.input.source_table}"
  })
  filename = "${local.sql_out_directory}/${split(".", each.key)[0]}.sql"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "aggregations"
  location                    = var.gcp.region
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "view-dataproduct" {
  for_each = local.sqlFiles

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "view-dataproduct-${split(".", each.key)[0]}"
  view       {
        query = file("${local.sql_out_directory}/${each.key}")
        use_legacy_sql = false
  }
}
