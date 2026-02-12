# Changelog

All notable changes to this project will be documented in this file.

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
