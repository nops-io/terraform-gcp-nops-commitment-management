# terraform-gcp-nops-commitment-management

Terraform module that provisions GCP infrastructure for [nOps](https://www.nops.io/) commitment management. It creates a dedicated CUD (Committed Use Discount) project, configures IAM for the nOps automation agent (service account), and optionally grants your nOps group access for human managers.

## What this module does

- **Creates a new GCP project** under your organization and billing account, with the APIs needed for commitments and CUD management.
- **Grants the nOps service account** project-level roles (e.g. Compute Viewer, Cloud Asset Viewer) and optional billing-account roles (billing viewer, order admin, CUD admin).
- **Defines and optionally grants** the **nOps Resource Manager** custom organization role (least-privilege permissions for creating/updating commitments, managing quotas, and asset export).
- **Grants the nOps service account** read access to your existing **billing export project** (for exported billing/commitment data).
- **Optionally grants your nOps group** project and billing access (compute viewer, nOps Resource Manager, billing viewer, CUD viewer) and optional org-level support ticket creation.

### Permissions by principal

Each grant is controlled by a variable (see [Inputs](#inputs-variables)).

#### Service account

| Scope | Role / permission |
|-------|-------------------|
| **Organization** | `roles/cloudsupport.techSupportEditor` |
| **Organization** | nOps Resource Manager (custom role) |
| **CUD project** | `nops_project_roles` (e.g. `roles/compute.viewer`, `roles/cloudasset.viewer`) |
| **CUD project** | nOps Resource Manager (custom role) |
| **Billing account** | `roles/billing.viewer` |
| **Billing account** | `roles/consumerprocurement.orderAdmin` |
| **Billing account** | `roles/recommender.billingAccountCudAdmin` |
| **Billing account** | `roles/billing.admin` (Billing Account Administrator) |
| **Billing export project** | `nops_billing_export_role` (e.g. `roles/viewer`) |

#### Group email

| Scope | Role / permission |
|-------|-------------------|
| **Organization** | `roles/browser` |
| **Organization** | `roles/cloudsupport.techSupportEditor` |
| **CUD project** | `roles/compute.viewer` |
| **CUD project** | nOps Resource Manager (custom role) |
| **Billing account** | `roles/billing.viewer` |
| **Billing account** | `roles/consumerprocurement.orderAdmin` |
| **Billing account** | `roles/recommender.billingAccountCudViewer` |
| **Billing account** | `roles/billing.admin` (Billing Account Administrator) |

#### Custom role: nOps Resource Manager

The custom role **nOps Resource Manager** (`nOpsResourceManager`) includes the following permissions. It can be granted at the organization and/or on the CUD project (see variables).

| Category | Permission |
|----------|------------|
| **Compute (commitments)** | `compute.commitments.create` |
| | `compute.commitments.update` |
| | `compute.commitments.updateReservations` |
| | `compute.commitments.get` |
| | `compute.commitments.list` |
| | `compute.regionOperations.get` |
| **Quotas (Service Usage)** | `serviceusage.quotas.get` |
| | `serviceusage.quotas.update` |
| | `serviceusage.services.get` |
| | `serviceusage.services.list` |
| **Quotas (Cloud Quotas)** | `cloudquotas.quotas.get` |
| | `cloudquotas.quotas.update` |
| **Asset export** | `cloudasset.assets.exportResource` |
| **Monitoring** | `monitoring.timeSeries.list` |

## Requirements

- [Terraform](https://www.terraform.io/) >= 1.0
- [Google provider](https://registry.terraform.io/providers/hashicorp/google/latest) >= 4.0
- Authenticate via `gcloud auth application-default login` or `GOOGLE_APPLICATION_CREDENTIALS`

### IAM permissions for the principal running apply

The identity running `terraform apply` / `tofu apply` needs the following at the **organization** (and elsewhere as needed):

- **Custom org role** (when `create_nops_resource_manager_role` is true): grant **Organization Role Administrator** (`roles/iam.organizationRoleAdmin`) on the organization so the principal can create/read/update the nOps Resource Manager custom role. Without this you get `403` on `iam.roles.get` for `organizations/<org_id>/roles/nOpsResourceManager`.

You also need the usual permissions to create projects, enable APIs, and manage IAM on the new project and billing account (e.g. Organization Admin, Billing Admin, or equivalent project/billing roles where the module operates).

## Usage

```hcl
module "nops_gcp_commitment_management" {
  source = "path/to/terraform-gcp-nops-commitment-management" # or git URL

  organization_id           = "123456789012"
  billing_account_id        = "XXXXXX-XXXXXX-XXXXXX"
  billing_export_project_id = "your-billing-export-project"

  nops_service_account_email = "your-nops-sa@project.iam.gserviceaccount.com"
  nops_group_email           = "xxxxxxxx-gcp-console@nops.io"

  project_id   = "your-globally-unique-project-id"
  project_name = "nOps CUD Purchases"
}

output "project_id" {
  value = module.nops_gcp_commitment_management.project_id
}

output "project_number" {
  value = module.nops_gcp_commitment_management.project_number
}
```

A full example with placeholders is in [`examples/basic/main.tf`](examples/basic/main.tf).

## Inputs (variables)

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `organization_id` | GCP Organization ID where the project will be created | `string` | required |
| `billing_account_id` | Billing account ID (e.g. `XXXXXX-XXXXXX-XXXXXX`) | `string` | required |
| `billing_export_project_id` | Project ID of the existing Billing Export project used for nOps | `string` | required |
| `nops_service_account_email` | nOps service account email for IAM grants | `string` | required |
| `nops_group_email` | nOps group email (e.g. from nOps UI) for human manager access | `string` | required |
| `project_id` | Globally unique ID for the new GCP project | `string` | required |
| `project_name` | Display name for the new project | `string` | required |
| `apis_to_enable` | APIs to enable on the new project | `list(string)` | (see [variables.tf](variables.tf)) |
| `nops_project_roles` | IAM roles for nOps SA on the new project | `list(string)` | `["roles/compute.viewer", "roles/cloudasset.viewer"]` |
| `grant_billing_viewer_on_billing_account` | Grant nOps SA `roles/billing.viewer` on billing account | `bool` | `true` |
| `grant_nops_billing_order_admin` | Grant nOps SA order admin (Flex/spend-based CUD) | `bool` | `true` |
| `grant_nops_billing_cud_admin` | Grant nOps SA CUD admin (recommendations) | `bool` | `true` |
| `grant_nops_billing_admin` | Grant nOps SA Billing Account Administrator on billing account | `bool` | `true` |
| `nops_billing_export_role` | Role for nOps SA on billing export project | `string` | `"roles/viewer"` |
| `create_nops_resource_manager_role` | Create the nOps Resource Manager custom role at org | `bool` | `true` |
| `nops_resource_manager_role_id` | ID for the custom role | `string` | `"nOpsResourceManager"` |
| `grant_nops_resource_manager_role_at_org` | Grant custom role to nOps SA at organization | `bool` | `true` |
| `grant_nops_resource_manager_role_at_project` | Grant custom role to nOps SA on CUD project | `bool` | `true` |
| `grant_nops_org_browser` | Grant nOps SA `roles/browser` at organization | `bool` | `true` |
| `grant_nops_org_tech_support_editor` | Grant nOps SA support ticket creation (paid support) | `bool` | `false` |
| `grant_nops_group_tech_support_editor` | Grant nOps group support ticket creation | `bool` | `false` |
| `grant_nops_group_billing_viewer` | Grant nOps group billing viewer on billing account | `bool` | `true` |
| `grant_nops_group_billing_cud_viewer` | Grant nOps group CUD viewer on billing account | `bool` | `true` |
| `grant_nops_group_order_admin` | Grant nOps group `roles/consumerprocurement.orderAdmin` on billing account | `bool` | `true` |
| `grant_nops_group_billing_admin` | Grant nOps group Billing Account Administrator on billing account | `bool` | `true` |
| `grant_nops_group_project_compute_viewer` | Grant nOps group compute viewer on CUD project | `bool` | `true` |
| `grant_nops_group_project_resource_manager` | Grant nOps group nOps Resource Manager on CUD project | `bool` | `true` |

See [variables.tf](variables.tf) for full descriptions and any additional options.

## Outputs

| Name | Description |
|------|-------------|
| `project_id` | ID of the created GCP project |
| `project_number` | Numeric project number |
| `project_name` | Display name of the created project |
| `nops_resource_manager_role_id` | Full resource name of the nOps Resource Manager custom role (or `null` if not created) |

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.
