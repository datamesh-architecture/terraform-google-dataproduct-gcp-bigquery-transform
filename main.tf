provider "google" {
  project = var.gcp.project
  region  = var.gcp.region
}

locals {
  sql_in_directory    = "${path.root}/sql"
  sqlTemplateInput    = fileset(local.sql_in_directory, "*.sql.tftpl")
}

data "local_file" "input_template" {
  for_each = local.sqlTemplateInput
  filename = "${local.sql_in_directory}/${each.key}"
}

data "template_file" "transform_sql" {
  for_each = data.local_file.input_template
  template = each.value.content
  vars = {
      source_table = var.input.source_table
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "aggregations"
  location                    = var.gcp.region
  default_table_expiration_ms = 3600000
}

resource "google_bigquery_table" "view-dataproduct" {
  for_each = data.template_file.transform_sql

  dataset_id = google_bigquery_dataset.dataset.dataset_id
  table_id   = "view-dataproduct-${split(".", each.key)[0]}"
  view       {
        query = each.value.rendered
        use_legacy_sql = false
  }
}
