locals {
  info_in_directory    = "${path.module}/info"
  info_out_directory   = "${path.root}/out/info"
  function_source_path = "${path.root}/out/archives/${var.domain}_${var.name}-info.zip"
  table_links          = google_bigquery_table.view-dataproduct.self_link
}

resource "local_file" "info_lambda_index_js" {
  content = templatefile("${local.info_in_directory}/index.js.tftpl", {
    response_message = jsonencode({
      domain = var.domain
      name   = var.name
      output = {
        locations = local.table_links
      }
    })
  })
  filename = "${local.info_out_directory}/index.js"
}

resource "local_file" "info_lambda_package_json" {
  content  = file("${local.info_in_directory}/package.json")
  filename = "${local.info_out_directory}/package.json"
}

data "archive_file" "info_lambda_archive" {
  type        = "zip"
  source_dir  = local.info_out_directory
  output_path = local.function_source_path

  depends_on = [local_file.info_lambda_index_js, local_file.info_lambda_package_json]
}

resource "google_storage_bucket" "bucket" {
  name                        = "${var.name}-info-gfc-source"
  location                    = var.gcp.region
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "function_source" {
  name   = "function-source-${data.archive_file.info_lambda_archive.output_md5}.zip"
  bucket = google_storage_bucket.bucket.name
  source = local.function_source_path

  depends_on = [data.archive_file.info_lambda_archive]
}

resource "google_cloudfunctions2_function" "function" {
  name     = "info"
  location = var.gcp.region

  build_config {
    runtime     = "nodejs18"
    entry_point = "info"

    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = google_storage_bucket_object.function_source.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "128Mi"
    timeout_seconds    = 10
  }
}