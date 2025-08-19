# Ensure API is enabled
resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloud_run_v2_service" "default" {
  name                = "custom-domain"
  location            = var.region
  project             = var.project_id
  deletion_protection = false

  template {
    containers {
#      image = "us-docker.pkg.dev/cloudrun/container/hello" # replace with your image later
        image = var.image
        # 👇 Tell Cloud Run to send traffic to port 80
      ports {
        name           = "http1"
        container_port = 80
    }
  }
   # optional: give more startup time
  timeout = "300s"
  }
}

# Public access
resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}













# Enable the API (safe to keep)
# resource "google_project_service" "run" {
#   project            = "ck-armageddon"
#   service            = "run.googleapis.com"
#   disable_on_destroy = false
# }

# # Public “hello” service — replace the image when you have your own
# resource "google_cloud_run_v2_service" "default" {
#   name                = "custom-domain"         # your service name
#   location            = "us-central1"
#   project             = "ck-armageddon"
#   deletion_protection = false

#   template {
#     containers {
#       image = "us-docker.pkg.dev/cloudrun/container/hello"
#     }
#   }
# }

# # (Optional but common) allow unauthenticated
# resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
#   project  = "ck-armageddon"
#   location = "us-central1"
#   name     = google_cloud_run_v2_service.default.name
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }
