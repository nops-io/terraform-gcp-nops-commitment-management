variable "organization_id" {
  description = "GCP Organization ID where the project will be created"
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID to associate with the new project (e.g. XXXXXX-XXXXXX-XXXXXX)"
  type        = string
}

variable "billing_export_project_id" {
  description = "Project ID of the existing Billing Export project used for nOps"
  type        = string
}

variable "nops_service_account_email" {
  description = "Email of the nOps service account to grant IAM roles for commitment management"
  type        = string
}

variable "project_id" {
  description = "ID for the new GCP project (must be globally unique)"
  type        = string
}

variable "project_name" {
  description = "Display name for the new GCP project"
  type        = string
}

variable "apis_to_enable" {
  description = "List of APIs to enable on the new project"
  type        = list(string)
  default = [
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

variable "nops_project_roles" {
  description = "IAM roles to grant the nOps service account on the new project. Note: roles/billing.viewer cannot be applied at project level; use billing account IAM instead (granted automatically when grant_billing_viewer is true)."
  type        = list(string)
  default = [
    "roles/compute.viewer",
    "roles/cloudasset.viewer"
  ]
}

variable "grant_billing_viewer_on_billing_account" {
  description = "Grant the nOps service account roles/billing.viewer on the billing account (required for billing/commitment visibility; this role cannot be granted at project level)."
  type        = bool
  default     = true
}

variable "nops_billing_export_role" {
  description = "IAM role to grant the nOps service account on the billing export project (for reading exported billing data). roles/billing.viewer is not valid on projects; use e.g. roles/viewer or roles/bigquery.dataViewer."
  type        = string
  default     = "roles/viewer"
}

# ------------------------------------------------------------------------------
# nOps Resource Manager role (organization-level)
# ------------------------------------------------------------------------------

variable "create_nops_resource_manager_role" {
  description = "Create the nOps Resource Manager custom role at the organization level (replaces gcloud iam roles create). Set to false if the role already exists."
  type        = bool
  default     = true
}

variable "nops_resource_manager_role_id" {
  description = "ID for the custom organization role (e.g. nOpsResourceManager). Must be unique within the organization."
  type        = string
  default     = "nOpsResourceManager"
}

variable "grant_nops_resource_manager_role_at_org" {
  description = "Grant the nOps Resource Manager custom role to the nOps service account at the organization level. Requires create_nops_resource_manager_role to be true."
  type        = bool
  default     = true
}

# ------------------------------------------------------------------------------
# Organization-level roles for Automation Agent (browser, support)
# ------------------------------------------------------------------------------

variable "grant_nops_org_browser" {
  description = "Grant the nOps service account roles/browser at the organization level (required for autonomous commitment management)."
  type        = bool
  default     = true
}

variable "grant_nops_org_tech_support_editor" {
  description = "Grant the nOps service account roles/cloudsupport.techSupportEditor at the organization level. Enable only if you have a paid support plan (Standard/Enhanced/Premium) and want support ticket creation."
  type        = bool
  default     = false
}
