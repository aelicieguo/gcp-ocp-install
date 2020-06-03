output "ocp_api_public_ip" {
  value = google_compute_address.ocp-api-public-ip
}

output "wildcard_public_ip" {
  value = google_compute_address.wildcard-public-ip
}

output "ssl_wildcard_public_ip" {
  value = google_compute_address.ssl-wildcard-public-ip
}
