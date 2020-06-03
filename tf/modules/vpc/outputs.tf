output "gcp_network" {
  value = google_compute_network.ocp
}

output "master_subnet" {
  value = google_compute_subnetwork.master-subnet
}

output "compute_subnet" {
  value = google_compute_subnetwork.compute-subnet
}
