output "project_id" {
  description = "ID of the created GCP project"
  value       = google_project.nops_project.project_id
}

output "project_number" {
  description = "Numeric project number of the created GCP project"
  value       = google_project.nops_project.number
}

output "project_name" {
  description = "Display name of the created GCP project"
  value       = google_project.nops_project.name
}

output "nops_resource_manager_role_id" {
  description = "Full resource name of the nOps Resource Manager custom role (e.g. organizations/123456789012/roles/nOpsResourceManager), or empty if create_nops_resource_manager_role is false."
  value       = var.create_nops_resource_manager_role ? google_organization_iam_custom_role.nops_resource_manager[0].id : null
}
