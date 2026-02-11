output "project_id" {
  description = "ID of the created GCP project"
  value       = google_project.nops_project.project_id
}

output "project_number" {
  description = "Numeric project number of the created GCP project"
  value       = google_project.nops_project.number
}

output "project_name" {
  description = "Display name of the created GCP project"
  value       = google_project.nops_project.name
}
