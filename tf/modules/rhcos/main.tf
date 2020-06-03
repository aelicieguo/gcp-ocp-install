# GCP Cloud Storage for IGN
resource "google_storage_bucket" "ocp" {
  name = "${var.ocp_infra_id}-${var.ocp_cluster_name}"
  location = upper(var.gcp_location)
}

# Upload image to GCP Cloud Storage
resource "google_storage_bucket_object" "rhcos-image" {
  name   = "rhcos.tar.gz"
  source = "../ocp/${var.ocp_cluster_name}/rhcos.tar.gz"
  bucket = google_storage_bucket.ocp.name
}

# Upload bootstrap.ign to GCP Cloud Storage
resource "google_storage_bucket_object" "bootstrap" {
  name   = "bootstrap.ign"
  source = "../ocp/${var.ocp_cluster_name}/bootstrap.ign"
  bucket = google_storage_bucket.ocp.name
}

# Upload master.ign to GCP Cloud Storage
resource "google_storage_bucket_object" "master" {
  name   = "master.ign"
  source = "../ocp/${var.ocp_cluster_name}/master.ign"
  bucket = google_storage_bucket.ocp.name
}

# Upload worker.ign to GCP Cloud Storage
resource "google_storage_bucket_object" "worker" {
  name   = "worker.ign"
  source = "../ocp/${var.ocp_cluster_name}/worker.ign"
  bucket = google_storage_bucket.ocp.name
}

# RHCOS Disk Image
resource "google_compute_image" "rhcos" {
  name = "${var.ocp_infra_id}-rhcos-image"

  raw_disk {
    source = google_storage_bucket_object.rhcos-image.self_link
  }
}
