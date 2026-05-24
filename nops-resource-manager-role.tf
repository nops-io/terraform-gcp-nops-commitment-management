# Custom organization-level role with minimum permissions for nOps to manage
# commitments and quotas

locals {
  nops_resource_manager_role_name = var.create_nops_resource_manager_role ? google_organization_iam_custom_role.nops_resource_manager[0].id : "organizations/${var.organization_id}/roles/${var.nops_resource_manager_role_id}"

  nops_resource_manager_permissions = [
    "cloudasset.assets.exportResource",
    "cloudquotas.quotas.get",
    "cloudquotas.quotas.update",
    "compute.commitments.create",
    "compute.commitments.get",
    "compute.commitments.list",
    "compute.commitments.update",
    "compute.commitments.updateReservations",
    "compute.regionOperations.get",
    "monitoring.timeSeries.list",
    "serviceusage.quotas.get",
    "serviceusage.quotas.update",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "serviceusage.services.use",
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
  org_id = var.organization_id
  role   = local.nops_resource_manager_role_name
  member = "serviceAccount:${var.nops_service_account_email}"
}
