# Enable Compute Engine API on the CUD purchase project
resource "google_project_service" "compute" {
  project = var.cud_purchase_project_id
  service = "compute.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}

# Enable Cloud Commerce Consumer Procurement API on the CUD purchase project
resource "google_project_service" "cloud_commerce_consumer_procurement" {
  project = var.cud_purchase_project_id
  service = "cloudcommerceconsumerprocurement.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}

# Enable Cloud Asset API on the CUD purchase project
resource "google_project_service" "cloud_asset" {
  project = var.cud_purchase_project_id
  service = "cloudasset.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}

# Enable Cloud Quotas API on the CUD purchase project
resource "google_project_service" "cloud_quotas" {
  project = var.cud_purchase_project_id
  service = "cloudquotas.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}

# Enable Service Usage API on the CUD purchase project
resource "google_project_service" "service_usage" {
  project = var.cud_purchase_project_id
  service = "serviceusage.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}

# Enable Recommender API on the CUD purchase project
resource "google_project_service" "recommender" {
  project = var.cud_purchase_project_id
  service = "recommender.googleapis.com"

  disable_on_destroy         = var.disable_apis_on_destroy
  disable_dependent_services = false
}
