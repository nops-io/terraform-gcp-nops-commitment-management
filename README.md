# terraform-gcp-nops-commitment-management

Terraform module that provisions GCP infrastructure for [nOps](https://www.nops.io/) commitment management. It configures an existing CUD (Committed Use Discount) purchase project with required APIs and IAM for the nOps automation agent (service account), and optionally grants your nOps Support group access for human managers.

## What this module does

- **Enables required APIs** on your existing CUD purchase project for commitments and CUD management.
- **Grants organization-level IAM** to the nOps service account and nOps Support group.
- **Grants the nOps service account** billing account roles and CUD purchase project IAM.
- **Defines and grants** the **nOps Resource Manager** custom organization role and all other required IAM bindings.
- **Grants nOps Support** CUD purchase project and billing account access.

## Module Structure

The module code is organized into separate files:
- **`apis.tf`** - Contains all GCP API enablement resources
- **`billing-iam.tf`** - Billing account-level IAM role resources
- **`cud-project.tf`** - CUD purchase project IAM grants
- **`org-iam.tf`** - Organization-level IAM role resources
- **`nops-resource-manager-role.tf`** - nOps Resource Manager custom role definition

## Overview

This module automatically enables the following APIs in the CUD purchase project:

**Required APIs (always enabled):**

| API Service | API Service ID | Scope |
|------------|----------------|-------|
| Compute Engine API | `compute.googleapis.com` | CUD Purchase Project |
| Cloud Commerce Consumer Procurement API | `cloudcommerceconsumerprocurement.googleapis.com` | CUD Purchase Project |
| Cloud Asset API | `cloudasset.googleapis.com` | CUD Purchase Project |
| Cloud Quotas API | `cloudquotas.googleapis.com` | CUD Purchase Project |
| Service Usage API | `serviceusage.googleapis.com` | CUD Purchase Project |
| Recommender API | `recommender.googleapis.com` | CUD Purchase Project |

### Organization IAM

The module grants the following roles on the organization (`organization_id`).

| Principal | Role | Role ID |
|-----------|------|---------|
| Service account (`nops_service_account_email`) | Cloud Asset Viewer | `roles/cloudasset.viewer` |
| Service account (`nops_service_account_email`) | Browser | `roles/browser` |
| Service account (`nops_service_account_email`) | Recommender Viewer | `roles/recommender.viewer` |
| Service account (`nops_service_account_email`) | Cloud SQL Viewer | `roles/cloudsql.viewer` |
| Service account (`nops_service_account_email`) | Cloud Run Viewer | `roles/run.viewer` |
| Service account (`nops_service_account_email`) | Compute Recommender Viewer | `roles/recommender.computeViewer` |
| Service account (`nops_service_account_email`) | Cloud Support Tech Support Editor (optional) | `roles/cloudsupport.techSupportEditor` |
| nOps Support (`nops_support_email`) | Browser | `roles/browser` |
| nOps Support (`nops_support_email`) | Compute Viewer | `roles/compute.viewer` |
| nOps Support (`nops_support_email`) | Cloud Support Tech Support Editor (optional) | `roles/cloudsupport.techSupportEditor` |

### Project IAM (CUD Purchase Project)

The module grants the following roles on the CUD purchase project. Provide your organization ID, existing CUD purchase project ID, nOps service account email, nOps Support email, and nOps Resource Manager role ID when invoking the module.

| Principal | Role | Role ID |
|-----------|------|---------|
| Service account (`nops_service_account_email`) | Compute Viewer | `roles/compute.viewer` |
| Service account (`nops_service_account_email`) | nOps Resource Manager | `organizations/<organization_id>/roles/<nops_resource_manager_role_id>` |
| nOps Support (`nops_support_email`) | Compute Viewer | `roles/compute.viewer` |
| nOps Support (`nops_support_email`) | nOps Resource Manager | `organizations/<organization_id>/roles/<nops_resource_manager_role_id>` |

### Billing Account IAM

The module grants the following roles on the billing account (`billing_account_id`).

| Principal | Role | Role ID |
|-----------|------|---------|
| Service account (`nops_service_account_email`) | Billing Account Viewer | `roles/billing.viewer` |
| Service account (`nops_service_account_email`) | Consumer Procurement Order Admin | `roles/consumerprocurement.orderAdmin` |
| Service account (`nops_service_account_email`) | Recommender Billing Account CUD Admin | `roles/recommender.billingAccountCudAdmin` |
| nOps Support (`nops_support_email`) | Billing Account Viewer | `roles/billing.viewer` |
| nOps Support (`nops_support_email`) | Consumer Procurement Order Admin | `roles/consumerprocurement.orderAdmin` |
| nOps Support (`nops_support_email`) | Recommender Billing Account CUD Viewer | `roles/recommender.billingAccountCudViewer` |

## Permissions by principal

All IAM roles listed in this module are always granted except `roles/cloudsupport.techSupportEditor` (optional; paid support plans only).

#### Service account

| Scope | Role / permission |
|-------|-------------------|
| **Organization** | `roles/cloudasset.viewer` |
| **Organization** | `roles/browser` |
| **Organization** | `roles/recommender.viewer` |
| **Organization** | `roles/cloudsql.viewer` |
| **Organization** | `roles/run.viewer` |
| **Organization** | `roles/recommender.computeViewer` |
| **Organization** | `roles/cloudsupport.techSupportEditor` (optional) |
| **Organization** | nOps Resource Manager (custom role) |
| **CUD project** | `roles/compute.viewer` |
| **CUD project** | nOps Resource Manager (custom role) |
| **Billing account** | `roles/billing.viewer` |
| **Billing account** | `roles/consumerprocurement.orderAdmin` |
| **Billing account** | `roles/recommender.billingAccountCudAdmin` |

#### nOps Support

| Scope | Role / permission |
|-------|-------------------|
| **Organization** | `roles/browser` |
| **Organization** | `roles/compute.viewer` |
| **Organization** | `roles/cloudsupport.techSupportEditor` (optional) |
| **CUD project** | `roles/compute.viewer` |
| **CUD project** | nOps Resource Manager (custom role) |
| **Billing account** | `roles/billing.viewer` |
| **Billing account** | `roles/consumerprocurement.orderAdmin` |
| **Billing account** | `roles/recommender.billingAccountCudViewer` |

#### Custom role: nOps Resource Manager

The custom role **nOps Resource Manager** (`nOpsResourceManager`) includes the following permissions. It can be granted at the organization and/or on the CUD project (see variables).

| Category | Permission |
|----------|------------|
| **Asset export** | `cloudasset.assets.exportResource` |
| **Quotas (Cloud Quotas)** | `cloudquotas.quotas.get` |
| | `cloudquotas.quotas.update` |
| **Compute (commitments)** | `compute.commitments.create` |
| | `compute.commitments.get` |
| | `compute.commitments.list` |
| | `compute.commitments.update` |
| | `compute.commitments.updateReservations` |
| | `compute.regionOperations.get` |
| **Monitoring** | `monitoring.timeSeries.list` |
| **Quotas (Service Usage)** | `serviceusage.quotas.get` |
| | `serviceusage.quotas.update` |
| | `serviceusage.services.get` |
| | `serviceusage.services.list` |
| | `serviceusage.services.use` |

## Requirements

- [Terraform](https://www.terraform.io/) >= 1.0
- [Google provider](https://registry.terraform.io/providers/hashicorp/google/latest) >= 4.0
- Authenticate via `gcloud auth application-default login` or `GOOGLE_APPLICATION_CREDENTIALS`

### IAM permissions for the principal running apply

The identity running `terraform apply` / `tofu apply` needs the following at the **organization** (and elsewhere as needed):

- **Custom org role** (when `create_nops_resource_manager_role` is true): grant **Organization Role Administrator** (`roles/iam.organizationRoleAdmin`) on the organization so the principal can create/read/update the nOps Resource Manager custom role. Without this you get `403` on `iam.roles.get` for `organizations/<org_id>/roles/nOpsResourceManager`.

You also need permissions to enable APIs and manage IAM on the CUD purchase project and billing account (e.g. Project IAM Admin, Service Usage Admin, Billing Admin, or equivalent roles where the module operates).

## Usage

```hcl
# Simple module invocation - enables all required APIs and grants IAM roles
# Required APIs are automatically enabled in the CUD purchase project:
# - Compute Engine API
# - Cloud Commerce Consumer Procurement API
# - Cloud Asset API
# - Cloud Quotas API
# - Service Usage API
# - Recommender API
module "nops_gcp_commitment_management" {
  source = "path/to/terraform-gcp-nops-commitment-management" # or git URL

  organization_id           = "123456789012"
  billing_account_id        = "XXXXXX-XXXXXX-XXXXXX"

  nops_service_account_email    = "your-nops-sa@project.iam.gserviceaccount.com"
  nops_support_email            = "xxxxxxxx-gcp-console@nops.io"
  nops_resource_manager_role_id = "nOpsResourceManager"

  cud_purchase_project_id       = "your-cud-purchase-project-id"

  # Optional: Cloud Support Tech Support Editor (paid support plans only)
  # grant_nops_sa_org_tech_support_editor = true
  # grant_nops_support_org_tech_support_editor = true

  # Optional: Disable APIs when the module is destroyed (default: false)
  # disable_apis_on_destroy = false
}

output "api_enablement_summary" {
  description = "Summary of enabled APIs on the CUD purchase project"
  value       = module.nops_gcp_commitment_management.enabled_apis_summary
}

output "cud_purchase_project_id" {
  description = "Project ID of the CUD purchase project where APIs are enabled"
  value       = module.nops_gcp_commitment_management.cud_purchase_project_id
}
```

A full example with placeholders is in [`examples/basic/main.tf`](examples/basic/main.tf).

### What Gets Enabled and Granted

**Required APIs Enabled (automatically, no configuration needed):**
- Compute Engine API (CUD Purchase Project)
- Cloud Commerce Consumer Procurement API (CUD Purchase Project)
- Cloud Asset API (CUD Purchase Project)
- Cloud Quotas API (CUD Purchase Project)
- Service Usage API (CUD Purchase Project)
- Recommender API (CUD Purchase Project)

**Organization IAM Granted (automatically, no configuration needed):**
- Service account: `roles/cloudasset.viewer`, `roles/browser`, `roles/recommender.viewer`, `roles/cloudsql.viewer`, `roles/run.viewer`, `roles/recommender.computeViewer`, nOps Resource Manager custom role
- nOps Support: `roles/browser`, `roles/compute.viewer`

**CUD Purchase Project IAM Granted (automatically, no configuration needed):**
- Service account: `roles/compute.viewer`, nOps Resource Manager custom role
- nOps Support: `roles/compute.viewer`, nOps Resource Manager custom role

**Billing Account IAM Granted (automatically, no configuration needed):**
- Service account: `roles/billing.viewer`, `roles/consumerprocurement.orderAdmin`, `roles/recommender.billingAccountCudAdmin`
- nOps Support: `roles/billing.viewer`, `roles/consumerprocurement.orderAdmin`, `roles/recommender.billingAccountCudViewer`

**Optional IAM (disabled by default):**
- Service account and nOps Support: `roles/cloudsupport.techSupportEditor` (paid support plans only)

## Inputs (variables)

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `organization_id` | GCP Organization ID for organization-level IAM roles and the custom role | `string` | required |
| `billing_account_id` | Billing account ID for billing account-level IAM grants (e.g. `XXXXXX-XXXXXX-XXXXXX`) | `string` | required |
| `nops_service_account_email` | nOps service account email for IAM grants | `string` | required |
| `nops_support_email` | nOps Support group email (e.g. from nOps UI) | `string` | required |
| `nops_resource_manager_role_id` | ID for the nOps Resource Manager custom role (e.g. `nOpsResourceManager`) | `string` | required |
| `cud_purchase_project_id` | Project ID of the existing CUD purchase GCP project | `string` | required |
| `disable_apis_on_destroy` | Disable APIs when the module is destroyed | `bool` | `false` |
| `create_nops_resource_manager_role` | Create the nOps Resource Manager custom role at org | `bool` | `true` |
| `grant_nops_sa_org_tech_support_editor` | Grant nOps SA `roles/cloudsupport.techSupportEditor` (paid support) | `bool` | `false` |
| `grant_nops_support_org_tech_support_editor` | Grant nOps Support `roles/cloudsupport.techSupportEditor` (paid support) | `bool` | `false` |

See [variables.tf](variables.tf) for full descriptions and any additional options.

## Outputs

| Name | Description |
|------|-------------|
| `cud_purchase_project_id` | Project ID of the CUD purchase project where APIs are enabled |
| `enabled_apis_summary` | Summary of enabled APIs on the CUD purchase project |
| `nops_resource_manager_role_id` | Full resource name of the nOps Resource Manager custom role |

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
