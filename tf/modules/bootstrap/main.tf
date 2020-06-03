# IGN for Bootstrap
data "ignition_config" "bootstrap-ign" {
   append {
    source = var.bootstrap_ign
    verification = ""
  }
}

# IP for Bootstrap
resource "google_compute_address" "bootstrap-ip" {
  name = "${var.ocp_infra_id}-bootstrap-public-ip"
}

# SSH from All to Bootstrap
resource "google_compute_firewall" "bootstrap-ssh" {
  name    = "${var.ocp_infra_id}-bootstrap-ssh"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.ocp_infra_id}-bootstrap"]
}

# Bootstrap Instance
resource "google_compute_instance" "bootstrap-instance" {
  name         = "${var.ocp_infra_id}-bootstrap"
  machine_type = var.gcp_bootstrap_machine_type
  zone         = element(var.gcp_availability_zones, count.index)

  count = 1

  tags = ["${var.ocp_infra_id}-bootstrap","${var.ocp_infra_id}-master"]

  boot_disk {
    initialize_params {
      image = var.rhcos_image
      size = var.gcp_bootstrap_root_volume_size
    }
  }

  network_interface {
    subnetwork = var.master_subnet
    network_ip = var.gcp_bootstrap_ip
    access_config {
      nat_ip = google_compute_address.bootstrap-ip.address
    }
  }

  metadata = {
    user-data = data.ignition_config.bootstrap-ign.rendered
  }
}
