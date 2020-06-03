# Control Plane Subnet
resource "google_compute_subnetwork" "master-subnet" {
  name          = "${var.ocp_infra_id}-master-subnet"
  ip_cidr_range = var.gcp_master_subnet
  region        = var.gcp_region
  network       = google_compute_network.ocp.name
}

# Control Plane NAT IP
resource "google_compute_address" "master-nat-ip" {
  name = "${var.ocp_infra_id}-master-nat-ip"
}

# Control Plane Router
resource "google_compute_router" "master-router" {
  name = "${var.ocp_infra_id}-master-router"
  network = google_compute_network.ocp.name
  bgp {
    asn = 64514
  }
}

# Control Plane NAT Router
resource "google_compute_router_nat" "master-nat" {
  name = "${var.ocp_infra_id}-master-nat"
  router = google_compute_router.master-router.name
  min_ports_per_vm = 7168

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.master-nat-ip.*.id
  
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.master-subnet.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Compute Subnet
resource "google_compute_subnetwork" "compute-subnet" {
  name          = "${var.ocp_infra_id}-compute-subnet"
  ip_cidr_range = var.gcp_compute_subnet
  region        = var.gcp_region
  network       = google_compute_network.ocp.name
}

# Compute NAT IP
resource "google_compute_address" "compute-nat-ip" {
  name = "${var.ocp_infra_id}-compute-nat-ip"
}

# Compute Router
resource "google_compute_router" "compute-router" {
  name = "${var.ocp_infra_id}-compute-router"
  network = google_compute_network.ocp.name
  bgp {
    asn = 64514
  }
}

# Compute NAT Router
resource "google_compute_router_nat" "compute-nat" {
  name = "${var.ocp_infra_id}-compute-nat"
  router = google_compute_router.compute-router.name
  min_ports_per_vm = 7168

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips = google_compute_address.compute-nat-ip.*.id
  
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.compute-subnet.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# VPC Network
resource "google_compute_network" "ocp" {
  name                    = var.ocp_infra_id
  auto_create_subnetworks = false
}
