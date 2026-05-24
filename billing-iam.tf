# Billing account IAM

# Service account: Billing Account Viewer
resource "google_billing_account_iam_member" "nops_sa_billing_viewer" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.viewer"
  member             = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Consumer Procurement Order Admin
resource "google_billing_account_iam_member" "nops_sa_order_admin" {
  billing_account_id = var.billing_account_id
  role               = "roles/consumerprocurement.orderAdmin"
  member             = "serviceAccount:${var.nops_service_account_email}"
}

# Service account: Recommender Billing Account CUD Admin
resource "google_billing_account_iam_member" "nops_sa_billing_cud_admin" {
  billing_account_id = var.billing_account_id
  role               = "roles/recommender.billingAccountCudAdmin"
  member             = "serviceAccount:${var.nops_service_account_email}"
}

# nOps Support: Billing Account Viewer
resource "google_billing_account_iam_member" "nops_support_billing_viewer" {
  billing_account_id = var.billing_account_id
  role               = "roles/billing.viewer"
  member             = "group:${var.nops_support_email}"
}

# nOps Support: Consumer Procurement Order Admin
resource "google_billing_account_iam_member" "nops_support_order_admin" {
  billing_account_id = var.billing_account_id
  role               = "roles/consumerprocurement.orderAdmin"
  member             = "group:${var.nops_support_email}"
}

# nOps Support: Recommender Billing Account CUD Viewer
resource "google_billing_account_iam_member" "nops_support_billing_cud_viewer" {
  billing_account_id = var.billing_account_id
  role               = "roles/recommender.billingAccountCudViewer"
  member             = "group:${var.nops_support_email}"
}
