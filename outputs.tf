# API Enablement Outputs
output "cud_purchase_project_id" {
  description = "Project ID of the CUD purchase project where APIs are enabled"
  value       = var.cud_purchase_project_id
}

output "enabled_apis_summary" {
  description = "Summary of enabled APIs on the CUD purchase project"
  value = {
    compute_engine_api_enabled                      = var.cud_purchase_project_id
    cloud_commerce_consumer_procurement_api_enabled = var.cud_purchase_project_id
    cloud_asset_api_enabled                         = var.cud_purchase_project_id
    cloud_quotas_api_enabled                        = var.cud_purchase_project_id
    service_usage_api_enabled                       = var.cud_purchase_project_id
    recommender_api_enabled                         = var.cud_purchase_project_id
  }
}

output "nops_resource_manager_role_id" {
  description = "Full resource name of the nOps Resource Manager custom role (e.g. organizations/123456789012/roles/nOpsResourceManager)."
  value       = local.nops_resource_manager_role_name
}
