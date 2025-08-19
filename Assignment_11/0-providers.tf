terraform {
  required_providers {
    google      = { source = "hashicorp/google",      version = "~> 6.0" }
    google-beta = { source = "hashicorp/google-beta", version = "~> 6.0" }
  }
}

variable "project_id" { default = "ck-armageddon" }
variable "region"     { default = "us-central1" }
variable "domain"     { default = "www.keyescloudsolutions.com" }

provider "google" {
  project = var.project_id
  region  = var.region
}

# Use beta for domain mappings (more reliable)
provider "google-beta" {
  project = var.project_id
  region  = var.region
}
