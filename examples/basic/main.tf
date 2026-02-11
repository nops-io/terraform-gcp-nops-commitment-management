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

  # Required: Organization, billing account, and billing export project information
  organization_id           = "123456789012"                # Replace with your GCP Organization ID
  billing_account_id        = "XXXXXX-XXXXXX-XXXXXX"        # Replace with your Billing Account ID
  billing_export_project_id = "your-billing-export-project" # Replace with your Billing Export Project ID

  # Required: nOps service account information for IAM roles
  nops_service_account_email = "your-nops-sa@project.iam.gserviceaccount.com"

  # Required: nOps group email to enable console access
  nops_group_email = "xxxxxxxx-gcp-console@nops.io"

  # Required: New project to create
  project_id   = "your-globally-unique-project-id" # Globally unique project ID
  project_name = "nOps CUD Purchases"

}

output "project_id" {
  value = module.nops_gcp_integration.project_id
}

output "project_number" {
  value = module.nops_gcp_integration.project_number
}
