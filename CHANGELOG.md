# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-05-23

### ⚠️ BREAKING CHANGES

- **No longer creates a GCP project** — Provide an existing CUD purchase project via `cud_purchase_project_id`. Removed `project_name`, `project_id`, `project_number`, and `project_name` outputs.
- **Removed `billing_export_project_id`** — Billing export project IAM belongs in `terraform-gcp-nops-integration`; removed `nops_billing_export_role` and related project IAM.
- **Renamed `nops_group_email` → `nops_support_email`** — Update all module invocations.
- **Renamed input `project_id` → `cud_purchase_project_id`** — Required project ID for the existing CUD purchase project.
- **Removed optional IAM grant variables** — All IAM bindings are always applied except `roles/cloudsupport.techSupportEditor` (paid support plans only). Removed `grant_*` toggles for billing account, organization, CUD project, and nOps Resource Manager grants.
- **Removed `apis_to_enable` and `nops_project_roles`** — APIs are defined explicitly in `apis.tf`; CUD project IAM is fixed to the documented role set.
- **Removed `roles/billing.admin`** — Billing account IAM now grants only `roles/billing.viewer`, `roles/consumerprocurement.orderAdmin`, and recommender billing account CUD roles.

### Added

- **`apis.tf`** — Explicit API enablement for Compute Engine, Cloud Commerce Consumer Procurement, Cloud Asset, Cloud Quotas, Service Usage, and Recommender on the CUD purchase project.
- **`billing-iam.tf`** — Billing account IAM for the nOps service account and nOps Support group.
- **`org-iam.tf`** — Organization-level IAM (replaces `nops-org-roles.tf`).
- **Organization IAM for service account** — `roles/cloudasset.viewer`, `roles/browser`, `roles/recommender.viewer`, `roles/cloudsql.viewer`, `roles/run.viewer`, `roles/recommender.computeViewer`.
- **Organization IAM for nOps Support** — `roles/browser`, `roles/compute.viewer`.
- **Outputs** — `cud_purchase_project_id`, `enabled_apis_summary`.
- **Variable** — `nops_resource_manager_role_id` (required).
- **Variable** — `disable_apis_on_destroy`.

### Changed

- **Module structure** — IAM split across `apis.tf`, `billing-iam.tf`, `cud-project.tf`, `org-iam.tf`, and `nops-resource-manager-role.tf`.
- **CUD project IAM** — Service account and nOps Support each receive `roles/compute.viewer` and the nOps Resource Manager custom role.
- **Billing account IAM** — Fixed role set per principal (see README); no `roles/billing.admin`.
- **nOps Resource Manager custom role** — Updated permissions list (includes `serviceusage.services.use`).
- **README** — API, organization, billing account, and CUD project IAM tables; updated usage example and inputs/outputs.

### Removed

- **`nops-org-roles.tf`** — Replaced by `org-iam.tf`.
- **Project creation** — `google_project` resource and associated variables/outputs.
- **Billing export project access** — `billing_export_project_id`, `nops_billing_export_role`, and `google_project_iam_member.nops_billing_export_viewer`.

## [1.0.5] - 2026-02-24

### Added

- **Billing account IAM**: Restored optional grant for the nOps service account—`roles/billing.admin` (Billing Account Administrator) on the billing account. Controlled by `grant_nops_billing_admin` (default `true`).
- **Billing account IAM**: Restored optional grant for the nOps group—`roles/billing.admin` (Billing Account Administrator) on the billing account. Controlled by `grant_nops_group_billing_admin` (default `true`).

## [1.0.4] - 2026-02-24

### Changed

- **Billing account IAM**: Use `roles/consumerprocurement.orderAdmin` only (for both nOps service account and nOps group). Removed `roles/billing.admin` (Billing Account Administrator) grants and variables `grant_nops_billing_admin` / `grant_nops_group_billing_admin`.

## [1.0.3] - 2026-02-24

### Added

- **Billing account IAM**: Optional grant for the nOps service account—`roles/billing.admin` (Billing Account Administrator) on the billing account. Controlled by `grant_nops_billing_admin` (default `true`).
- **Billing account IAM**: Optional grant for the nOps group—`roles/billing.admin` (Billing Account Administrator) on the billing account. Controlled by `grant_nops_group_billing_admin` (default `true`). *(Removed in 1.0.4 in favor of orderAdmin.)*

## [1.0.2] - 2026-02-24

### Added

- **Billing account IAM**: Optional grant for the nOps group—`roles/consumerprocurement.orderAdmin` on the billing account (for spend-based/Flex CUD purchasing by human managers). Controlled by `grant_nops_group_order_admin` (default `true`).

## [1.0.1] - 2026-02-12

### Fixed

- **nops-org-roles.tf**: Use `group:` prefix for `nops_group_email` in `roles/browser` grant instead of `serviceAccount:`. The nOps group email is a Google group and must appear as `group:...` per GCP IAM member types.

## [1.0.0] - 2026-02-11

### Added

- **Terraform module** for GCP nOps commitment management: provisions a dedicated CUD project, IAM for the nOps automation agent (service account), and optional human-manager access via an nOps group.
- **CUD project** (`cud-project.tf`): Creates a new GCP project under the given organization and billing account; enables required APIs (Compute, Cloud Billing, IAM, Resource Manager, Consumer Procurement, Cloud Asset, Cloud Quotas, Service Usage, Recommender); grants the nOps service account configurable project roles (e.g. `roles/compute.viewer`, `roles/cloudasset.viewer`); optionally grants the custom nOps Resource Manager role on the project for resource-based commitment purchasing.
- **nOps group access on the CUD project**: Optional project-level `roles/compute.viewer` and nOps Resource Manager for the nOps group (human managers).
- **Billing account IAM**: Optional grants for the nOps service account—`roles/billing.viewer`, `roles/consumerprocurement.orderAdmin` (Flex/spend-based CUD), `roles/recommender.billingAccountCudAdmin` (CUD recommendations); optional grants for the nOps group—`roles/billing.viewer`, `roles/recommender.billingAccountCudViewer`.
- **Billing export project access**: Grants the nOps service account a configurable role (default `roles/viewer`) on the existing billing export project for reading exported billing/commitment data.
- **Custom organization role** (`nops-resource-manager-role.tf`): Defines the **nOps Resource Manager** custom role with least-privilege permissions for compute commitments (create/update/get/list), region operations, quotas (serviceusage/cloudquotas), cloud asset export, and monitoring; optional creation and grant at organization level and/or on the CUD project.
- **Organization-level roles** (`nops-org-roles.tf`): Optional `roles/browser` for the nOps service account (resource discovery); optional `roles/cloudsupport.techSupportEditor` for the nOps service account and nOps group (paid support plans only).
- **Variables** (`variables.tf`): Inputs for organization ID, billing account, billing export project, nOps service account and group emails, project ID/name, APIs to enable, project roles, and feature flags for all optional IAM grants and the custom role.
- **Outputs** (`outputs.tf`): `project_id`, `project_number`, `project_name`, and `nops_resource_manager_role_id` (when the custom role is created).
- **Example** (`examples/basic/main.tf`): Basic module usage with placeholder values for organization, billing, and nOps identifiers.
- **Versioning**: `versions.tf` with Terraform `>= 1.0` and `hashicorp/google` `>= 4.0`; `VERSION` file (1.0.0); `.gitignore` for Terraform and IDE artifacts.
