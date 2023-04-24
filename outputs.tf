output "project" {
  value = var.gcp.project
}

output "view" {
  value = google_bigquery_table.view-dataproduct.table_id
}
