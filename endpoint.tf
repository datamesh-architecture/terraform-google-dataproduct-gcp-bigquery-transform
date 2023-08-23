locals {
  info_in_directory    = "${path.module}/info"
  info_out_directory   = "${path.root}/out/info"
  function_source_path = "${path.root}/out/archives/${var.teamId}_${var.name}-info.zip"
  table_views         = google_bigquery_table.view-dataproduct
}

resource "local_file" "info_lambda_index_js" {
  content = templatefile("${local.info_in_directory}/index.js.tftpl", {
    response_message = jsonencode({
      info = {
        name = var.name
      }
      owner = {
        teamId = var.teamId
      }
      outputPorts = {
        locations = [for view in local.table_views : view.self_link]
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
  name     = "info-dataproducts-transform"
  location = var.gcp.region

  build_config {
    runtime     = "nodejs18"
    entry_point = "info-dataproducts-transform"

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

data "google_iam_policy" "allow_invocations" {
  binding {
    role    = "roles/run.invoker"
    members = var.output.discovery_access
  }
}

# set iam policy of underlying cloud run service
# use policy of cloud run service to support "allUsers" and "allAuthenticatedUsers" as members
resource "google_cloud_run_service_iam_policy" "policy" {
  project     = google_cloudfunctions2_function.function.project
  location    = google_cloudfunctions2_function.function.location
  service     = google_cloudfunctions2_function.function.service_config[0].service
  policy_data = data.google_iam_policy.allow_invocations.policy_data
}
