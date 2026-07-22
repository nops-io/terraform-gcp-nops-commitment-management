# Project IAM (CUD Purchase Project)

# Service account: Compute Viewer
resource "google_project_iam_member" "nops_sa_compute_viewer" {
  project = var.cud_purchase_project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: nOps Resource Manager custom role
resource "google_project_iam_member" "nops_sa_resource_manager_at_project" {
  project = var.cud_purchase_project_id
  role    = local.nops_resource_manager_role_name
  member  = "serviceAccount:${var.nops_service_account_email}"
}

# nOps Support: Compute Viewer
resource "google_project_iam_member" "nops_support_compute_viewer" {
  project = var.cud_purchase_project_id
  role    = "roles/compute.viewer"
  member  = "group:${var.nops_support_email}"
}