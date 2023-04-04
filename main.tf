provider "google" {
  project = var.gcp.project
  region  = var.gcp.region
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "aggregations"
  location                    = var.gcp.region
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "default" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "view-dataproduct-${var.name}-${var.name}"
  view       {
        query = "SELECT * FROM ${var.source_table}"
  }
}
