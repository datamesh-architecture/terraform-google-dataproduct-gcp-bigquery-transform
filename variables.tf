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

variable "input" {
  type = object({
      source_table = string
  })
  description = <<EOT
    source_table = The name of the BigQuery source table
    transform = Path to a SQL file, which should be used to transform the input data
  EOT
}

variable "output" {
  type = object({
    discovery_access = list(string)
  })
  description = <<EOT
discovery_access: List of users with access to the discovery endpoint
EOT
}
