# variables.tf
# variable "project_id" { default = "ck-armageddon" }
# variable "region"     { default = "us-central1" }
variable "image" {
  # replace with your pushed image if different
  default = "us-central1-docker.pkg.dev/ck-armageddon/web/my-nginx-site:1"
}
