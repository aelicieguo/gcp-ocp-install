# Kubernetes API
resource "google_compute_firewall" "api" {
  name    = "${var.ocp_infra_id}-api"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.ocp_infra_id}-master"]
}

# OCP Bootstrap
resource "google_compute_firewall" "mcs" {
  name    = "${var.ocp_infra_id}-mcs"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["22623"]
  }

  source_ranges = [var.cluster_public_ip]
  target_tags = ["${var.ocp_infra_id}-master"]
}

# GCP Health Check
resource "google_compute_firewall" "health-checks" {
  name    = "${var.ocp_infra_id}-health-checks"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["6080","22624"]
  }

  source_ranges = ["35.191.0.0/16","209.85.152.0/22","209.85.204.0/22"]
  target_tags = ["${var.ocp_infra_id}-master"]
}

# OCP ETCD
resource "google_compute_firewall" "etcd" {
  name    = "${var.ocp_infra_id}-etcd"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["2379-2380"]
  }

  source_tags = ["${var.ocp_infra_id}-master"]
  target_tags = ["${var.ocp_infra_id}-master"]
}


resource "google_compute_firewall" "control-plane" {
  name    = "${var.ocp_infra_id}-control-plane"
  network = var.gcp_network

  allow {
    protocol = "tcp"
    ports    = ["10257","10259"]
  }

  source_tags = ["${var.ocp_infra_id}-master","${var.ocp_infra_id}-worker"]
  target_tags = ["${var.ocp_infra_id}-master"]
}

# SSH within Subnet
resource "google_compute_firewall" "internal-network" {
  name    = "${var.ocp_infra_id}-internal-network"
  network = var.gcp_network

  allow {
    protocol = "icmp"
}

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.gcp_cluster_network_cidr}"]
  target_tags = ["${var.ocp_infra_id}-master","${var.ocp_infra_id}-worker"]
}

# OCP and Kubernetes Network
resource "google_compute_firewall" "internal-cluster" {
  name    = "${var.ocp_infra_id}-internal-cluster"
  network = var.gcp_network

  allow {
    protocol = "udp"
    ports    = ["4789","6081","9000-9999","10256","30000-32767"]
  }

  allow {
    protocol = "tcp"
    ports    = ["9000-9999","10249-10259","10250","30000-32767"]
  }

  source_ranges = [var.gcp_master_subnet, var.gcp_compute_subnet]
  target_tags = ["${var.ocp_infra_id}-master","${var.ocp_infra_id}-worker"]
}
