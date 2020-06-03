output "cluster_public_ip" {
  value = google_compute_address.cluster-public-ip
}

output "cluster_private_ip" {
  value = google_compute_address.cluster-private-ip
}

output "wildcard_public_ip" {
  value = google_compute_address.wildcard-public-ip
}
