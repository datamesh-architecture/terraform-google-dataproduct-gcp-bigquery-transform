terraform {
  required_version = ">=1.3.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=4.51.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = ">=2.4.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
}
