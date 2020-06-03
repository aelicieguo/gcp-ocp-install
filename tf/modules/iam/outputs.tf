output "master_sa" {
  value = google_service_account.master-sa
}

output "compute_sa" {
  value = google_service_account.compute-sa
}
