provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.dataset
  location                    = var.gcp_region
  default_table_expiration_ms = 3600000
}
