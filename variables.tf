variable "gcp" {
  type = object({
    project = string
    region  = string
  })
  sensitive   = true
  description = "GCP related information and credentials"
}

variable "domain" {
  type        = string
  description = "The domain of the data product"
}

variable "name" {
  type        = string
  description = "The name of the data product"
}

variable "source_table" {
  type        = string
  description = "The name of the source table"
}

variable "transform" {
  type = object({
    query = string
  })
  description = "Path to a SQL file, which should be used to transform the input data"
}