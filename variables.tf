
variable "name" {
  type = string
  description = "The name of the data product"
}

variable "dataset_id" {
  type = string
  description = "The id of the BigQuery dataset"
}

variable "viewname" {
  type = string
  description = "The name of the BigQuery view"
}