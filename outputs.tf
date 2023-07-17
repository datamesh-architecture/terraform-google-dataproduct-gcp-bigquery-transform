output "project" {
  value = var.gcp.project
}

output "view" {
  value = [
  for v in google_bigquery_table.view-dataproduct : v.table_id
  ]
}
