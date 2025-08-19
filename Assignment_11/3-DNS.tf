# resource "google_cloud_run_v2_service" "default" {
#   name                = "keyescloud-service"
#   location            = var.region
#   project             = var.project_id
#   deletion_protection = false

#   template {
#     containers {
#       image = "us-central1-docker.pkg.dev/${var.project_id}/web/my-nginx-site:1"
#       ports {
#         container_port = 8080
#       }
#     }
#   }
# }

# resource "google_cloud_run_v2_service_iam_member" "public_invoker" {
#   project  = var.project_id
#   location = var.region
#   name     = google_cloud_run_v2_service.default.name
#   role     = "roles/run.invoker"
#   member   = "allUsers"
# }

resource "google_cloud_run_domain_mapping" "default" {
  name     = "www.keyescloudsolutions.com"
  location = google_cloud_run_v2_service.default.location

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.default.name
  }

  depends_on = [google_project_service.run]
}







# # Project data (used as the namespace for the mapping)
# # data "google_project" "project" {}
# resource "google_cloud_run_domain_mapping" "default" {
#           provider = google-beta

# # Map www.bbljanitorialservices.com -> Cloud Run service

#   name     = "www.keyescloudsolutions.com"
#   location = google_cloud_run_v2_service.default.location

#   metadata {
#     namespace = "ck-armageddon"
#   }

#   spec {
#     route_name = google_cloud_run_v2_service.default.name
#   }

#   depends_on = [google_project_service.run]
# }

