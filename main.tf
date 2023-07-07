provider "google" {
  project = var.gcp.project
  region  = var.gcp.region
}

locals {
  sql_in_directory    = "${path.module}/sql"
  sql_out_directory   = "${path.root}/out_sql"
}

resource "local_file" "transform_sql" {
  content = templatefile("${local.sql_in_directory}/transform.sql.tftpl", {
      source_table = "${var.input.source_table}"
  })
  filename = "${local.sql_out_directory}/transform.sql"
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "aggregations"
  location                    = var.gcp.region
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "view-dataproduct" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "view-dataproduct-${var.name}"
  view       {
        query = var.input.transform == null ? file("${local.sql_out_directory}/transform.sql") : file("${path.cwd}/${var.input.transform}")
        use_legacy_sql = false
  }
}
