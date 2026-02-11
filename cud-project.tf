# New GCP project for nOps commitment management
resource "google_project" "nops_project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.organization_id
  billing_account = var.billing_account_id
}

# Enable required APIs on the new project
resource "google_project_service" "apis" {
  for_each = toset(var.apis_to_enable)
  project  = google_project.nops_project.project_id
  service  = each.value

  disable_dependent_services = false
}

# Grant nOps service account IAM roles on the new project
resource "google_project_iam_member" "nops_sa_roles" {
  for_each = toset(var.nops_project_roles)
  project  = google_project.nops_project.project_id
  role     = each.value
  member   = "serviceAccount:${var.nops_service_account_email}"
}

# Grant nOps SA billing.viewer on the billing account (project-level binding not supported by GCP)
resource "google_billing_account_iam_member" "nops_billing_viewer" {
  count              = var.grant_billing_viewer_on_billing_account ? 1 : 0
  billing_account_id  = var.billing_account_id
  role                = "roles/billing.viewer"
  member              = "serviceAccount:${var.nops_service_account_email}"
}

# Grant nOps SA read access to the billing export project (for exported billing/commitment data)
resource "google_project_iam_member" "nops_billing_export_viewer" {
  project = var.billing_export_project_id
  role    = var.nops_billing_export_role
  member  = "serviceAccount:${var.nops_service_account_email}"
}
