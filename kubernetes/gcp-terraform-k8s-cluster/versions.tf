terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "7.18.0"
    }
  }
}

provider "google" {
  # Configuration options
  zone    = var.zone
  project = var.project_id
}
