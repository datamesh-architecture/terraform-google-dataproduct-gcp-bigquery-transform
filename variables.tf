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
