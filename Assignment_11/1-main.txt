terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "ck-armageddon"
  region  = "us-central1"
}

# (Optional) Make sure APIs are on
resource "google_project_service" "run" {
  project = "ck-armageddon"
  service = "run.googleapis.com"
  disable_on_destroy = false
}

variable "rev_marker" {
  description = "Bump this (r1,r2,r3,r4) to force a new revision with same image"
  type        = string
  default     = "r4"
}

resource "google_cloud_run_v2_service" "ck_cloud_run" {
  name     = "cloudrun-service"
  location = "us-central1"
  project  = "ck-armageddon"
  ingress  = "INGRESS_TRAFFIC_ALL"
  deletion_protection = false

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      # No-op knob to create distinct revisions without changing code
      env {
        name  = "REV_MARKER"
        value = var.rev_marker
      }
    }
  }

  # === Add traffic blocks AFTER created 4 revisions  ===
  traffic {
    percent  = 40
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
    revision = "cloudrun-service-00001-4hp"  
  }
  traffic {
    percent  = 40
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
    revision = "cloudrun-service-00002-glf"  
  }
  traffic {
    percent  = 10
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
    revision = "cloudrun-service-00003-bfp"  
  }
  traffic {
    percent  = 10
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_REVISION"
    revision = "cloudrun-service-00004-2dh"  
  }
}

# Public access
resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = "ck-armageddon"
  location = "us-central1"
  name     = google_cloud_run_v2_service.ck_cloud_run.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "cloud_run_url" {
  value = google_cloud_run_v2_service.ck_cloud_run.uri
}

# Helps you capture revision names as you create them
output "latest_ready_revision" {
  value = google_cloud_run_v2_service.ck_cloud_run.latest_ready_revision
}
