# Organization-level roles for the nOps Automation Agent (Service Account).
# These are required for autonomous commitment management and optional support features.

# roles/browser: Required for nOps to browse and discover resources at org level.
resource "google_organization_iam_member" "nops_browser" {
  count = var.grant_nops_org_browser ? 1 : 0

  org_id = var.organization_id
  role   = "roles/browser"
  member = "group:${var.nops_group_email}"
}

# roles/cloudsupport.techSupportEditor: Optional; enable only if you have a paid
# support plan (Standard/Enhanced/Premium) and want the service account to create
# support tickets.
resource "google_organization_iam_member" "nops_tech_support_editor" {
  count = var.grant_nops_org_tech_support_editor ? 1 : 0

  org_id = var.organization_id
  role   = "roles/cloudsupport.techSupportEditor"
  member = "serviceAccount:${var.nops_service_account_email}"
}

# roles/cloudsupport.techSupportEditor for nOps group (use the group email shown in nOps UI, e.g. gcp-cm-XXXX@nops.io).
# Paid support plans only.
resource "google_organization_iam_member" "nops_group_tech_support_editor" {
  count = var.grant_nops_group_tech_support_editor && var.nops_group_email != "" ? 1 : 0

  org_id = var.organization_id
  role   = "roles/cloudsupport.techSupportEditor"
  member = "group:${var.nops_group_email}"
}
