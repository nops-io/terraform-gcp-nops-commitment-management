terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  # Configure via GOOGLE_APPLICATION_CREDENTIALS or gcloud auth application-default login
}

module "nops_gcp_commitment_management_integration" {
  source = "../.." # Adjust path if using from elsewhere

  # Required: Organization and billing account information
  organization_id    = "123456789012"         # Replace with your GCP Organization ID
  billing_account_id = "XXXXXX-XXXXXX-XXXXXX" # Replace with your Billing Account ID

  # Required: nOps service account and support group for IAM roles
  nops_service_account_email    = "your-nops-sa@project.iam.gserviceaccount.com"
  nops_support_email            = "xxxxxxxx-gcp-console@nops.io"
  nops_resource_manager_role_id = "nOpsResourceManager"

  # Required: Existing CUD purchase project
  cud_purchase_project_id = "your-cud-purchase-project-id"

  # Optional: Grant Cloud Support Tech Support Editor at the organization level (paid support plans only)
  # grant_nops_sa_org_tech_support_editor = true
  # grant_nops_support_org_tech_support_editor = true

}

output "api_enablement_summary" {
  description = "Summary of enabled APIs on the CUD purchase project"
  value       = module.nops_gcp_commitment_management_integration.enabled_apis_summary
}

output "cud_purchase_project_id" {
  description = "Project ID of the CUD purchase project where APIs are enabled"
  value       = module.nops_gcp_commitment_management_integration.cud_purchase_project_id
}
