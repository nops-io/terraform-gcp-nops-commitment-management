# Organization-level IAM

# Service account: Cloud Asset Viewer
resource "google_organization_iam_member" "nops_sa_cloudasset_viewer" {
  org_id = var.organization_id
  role   = "roles/cloudasset.viewer"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Browser
resource "google_organization_iam_member" "nops_sa_browser" {
  org_id = var.organization_id
  role   = "roles/browser"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Recommender Viewer
resource "google_organization_iam_member" "nops_sa_recommender_viewer" {
  org_id = var.organization_id
  role   = "roles/recommender.viewer"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Cloud SQL Viewer
resource "google_organization_iam_member" "nops_sa_cloudsql_viewer" {
  org_id = var.organization_id
  role   = "roles/cloudsql.viewer"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Cloud Run Viewer
resource "google_organization_iam_member" "nops_sa_run_viewer" {
  org_id = var.organization_id
  role   = "roles/run.viewer"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Compute Recommender Viewer
resource "google_organization_iam_member" "nops_sa_recommender_compute_viewer" {
  org_id = var.organization_id
  role   = "roles/recommender.computeViewer"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Cloud Support Tech Support Editor (paid support plans only)
resource "google_organization_iam_member" "nops_sa_tech_support_editor" {
  count = var.grant_nops_sa_org_tech_support_editor ? 1 : 0

  org_id = var.organization_id
  role   = "roles/cloudsupport.techSupportEditor"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# nOps Support: Browser
resource "google_organization_iam_member" "nops_support_browser" {
  org_id = var.organization_id
  role   = "roles/browser"
  member = "group:${var.nops_support_email}"
}

# nOps Support: Compute Viewer
resource "google_organization_iam_member" "nops_support_compute_viewer" {
  org_id = var.organization_id
  role   = "roles/compute.viewer"
  member = "group:${var.nops_support_email}"
}

# nOps Support: Cloud Support Tech Support Editor (paid support plans only)
resource "google_organization_iam_member" "nops_support_tech_support_editor" {
  count = var.grant_nops_support_org_tech_support_editor ? 1 : 0

  org_id = var.organization_id
  role   = "roles/cloudsupport.techSupportEditor"
  member = "group:${var.nops_support_email}"
}
