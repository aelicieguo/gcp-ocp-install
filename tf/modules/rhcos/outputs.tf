output "bootstrap_ign" {
  value = google_storage_bucket_object.bootstrap
}

output "master_ign" {
  value = google_storage_bucket_object.master
}

output "compute_ign" {
  value = google_storage_bucket_object.worker
}

output "rhcos_image" {
  value = google_compute_image.rhcos
}
