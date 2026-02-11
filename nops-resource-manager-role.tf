# Custom organization-level role with minimum permissions for nOps to manage
# commitments and quotas

locals {
  nops_resource_manager_permissions = [
    # Compute Lifecycle (Action Layer)
    "compute.commitments.create",
    "compute.commitments.update",
    "compute.commitments.updateReservations",
    "compute.commitments.get",
    "compute.commitments.list",
    "compute.regionOperations.get",
    # Reliability (Auto-Fix Quotas)
    "serviceusage.quotas.get",
    "serviceusage.quotas.update",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "cloudquotas.quotas.get",
    "cloudquotas.quotas.update",
    # Asset Export (Bulk Visibility)
    "cloudasset.assets.exportResource",
    # Monitoring
    "monitoring.timeSeries.list",
  ]
}

resource "google_organization_iam_custom_role" "nops_resource_manager" {
  count = var.create_nops_resource_manager_role ? 1 : 0

  org_id      = var.organization_id
  role_id     = var.nops_resource_manager_role_id
  title       = "nOps Resource Manager"
  description = "Least-privilege role for managing Compute Commitments and Quotas"
  stage       = "GA"
  permissions = local.nops_resource_manager_permissions
}

# Grant the custom role to the nOps service account at the organization level.
resource "google_organization_iam_member" "nops_resource_manager_role" {
  count = var.create_nops_resource_manager_role && var.grant_nops_resource_manager_role_at_org ? 1 : 0

  org_id = var.organization_id
  role   = google_organization_iam_custom_role.nops_resource_manager[0].id
  member = "serviceAccount:${var.nops_service_account_email}"
}
