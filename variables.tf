variable "gcp_project" {
  type = string
  description = "The name of the gcp project"
}

variable "gcp_region" {
  type = string
  description = "The name of the gcp region"
}

variable "name" {
  type = string
  description = "The name of the data product"
}

variable "dataset" {
  type = string
  description = "The id of the BigQuery dataset"
}

variable "viewname" {
  type = string
  description = "The name of the BigQuery view"
}