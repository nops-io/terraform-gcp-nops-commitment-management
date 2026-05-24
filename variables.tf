variable "organization_id" {
  description = "GCP Organization ID used for organization-level IAM roles and the nOps Resource Manager custom role"
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID for billing account-level IAM grants (e.g. XXXXXX-XXXXXX-XXXXXX)"
  type        = string
}

variable "nops_service_account_email" {
  description = "Email of the nOps service account to grant IAM roles for commitment management"
  type        = string
}

variable "cud_purchase_project_id" {
  description = "Project ID of the existing CUD purchase GCP project where APIs are enabled and IAM roles are granted"
  type        = string
}

variable "disable_apis_on_destroy" {
  description = "Whether to disable APIs when the Terraform resource is destroyed"
  type        = bool
  default     = false
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
  description = "ID for the nOps Resource Manager custom organization role (e.g. nOpsResourceManager). Used when granting the role and when create_nops_resource_manager_role is true."
  type        = string
}

# ------------------------------------------------------------------------------
# Organization-level IAM (optional)
# ------------------------------------------------------------------------------

variable "nops_support_email" {
  description = "nOps Support group email (e.g. XXXXX-gcp-console@nops.io from the nOps UI). Used for organization, CUD project, and billing account IAM grants."
  type        = string
}

variable "grant_nops_sa_org_tech_support_editor" {
  description = "Grant the nOps service account roles/cloudsupport.techSupportEditor at the organization level. Paid support plans only."
  type        = bool
  default     = false
}

variable "grant_nops_support_org_tech_support_editor" {
  description = "Grant the nOps Support group (nops_support_email) roles/cloudsupport.techSupportEditor at the organization level. Paid support plans only."
  type        = bool
  default     = false
}
