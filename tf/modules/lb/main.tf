# OCP API LB Frontend Public IP
resource "google_compute_address" "cluster-public-ip" {
  name = "${var.ocp_infra_id}-cluster-public-ip"
}

# OCP API-INT LB Frontend Private IP
resource "google_compute_address" "cluster-private-ip" {
  name = "${var.ocp_infra_id}-cluster-private-ip"
  region = var.gcp_region
  subnetwork = var.master_subnet
}

# OCP wildcard LB Frontend Public IP
resource "google_compute_address" "wildcard-public-ip" {
  name = "${var.ocp_infra_id}-wildcard-public-ip"
}

# OCP API Target Pool
resource "google_compute_target_pool" "api-target-pool" {
  name = "${var.ocp_infra_id}-api-target-pool"
  
  instances = var.api_instance
}

# OCP API Forwarding Rule
resource "google_compute_forwarding_rule" "api-forwarding-rule" {
  name = "${var.ocp_infra_id}-api-forwarding-rule"

  ip_address = google_compute_address.cluster-public-ip.address
  target = google_compute_target_pool.api-target-pool.id
  port_range = 6443
}

# OCP IGN Health Check
resource "google_compute_health_check" "ign-http-health-check" {
  name = "${var.ocp_infra_id}-ign-http-health-check"
  http_health_check {
    port = 22624
    request_path = "/healthz"
  }
}

# OCP IGN Backend Service
resource "google_compute_region_backend_service" "ign-backend" {
  name = "ign-backend"
  region = var.gcp_region
  health_checks = [google_compute_health_check.ign-http-health-check.id]
}

# OCP IGN Forwarding Rule
resource "google_compute_forwarding_rule" "ign-forwarding-rule" {
  name = "${var.ocp_infra_id}-api-forwarding-rule"
  region = var.gcp_region

  load_balancing_scheme = "INTERNAL"

  ip_address = google_compute_address.cluster-private-ip.address
  backend_service = google_compute_region_backend_service.ign-backend.id
  network = var.gcp_network
  subnetwork = var.master_subnet

  ports = ["22623"]
}

# OCP API-INT Health Check
resource "google_compute_health_check" "api-int-http-health-check" {
  name = "${var.ocp_infra_id}-api-int-http-health-check"
  http_health_check {
    port = 6080
    request_path = "/readyz"
  }
}

# OCP API-INT Backend Service
resource "google_compute_region_backend_service" "api-int-backend" {
  name = "api-int-backend"
  region = var.gcp_region
  health_checks = [google_compute_health_check.api-int-http-health-check.id]
}

# OCP API-INT Forwarding Rule
resource "google_compute_forwarding_rule" "api-int-forwarding-rule" {
  name = "${var.ocp_infra_id}-api-int-forwarding-rule"
  region = var.gcp_region

  load_balancing_scheme = "INTERNAL"

  ip_address = google_compute_address.cluster-private-ip.address
  backend_service = google_compute_region_backend_service.api-int-backend.id
  network = var.gcp_network
  subnetwork = var.master_subnet

  ports = ["6443"]
}

# OCP wildcard Target Pool
resource "google_compute_target_pool" "wildcard-target-pool" {
  name = "${var.ocp_infra_id}-wildcard-target-pool"
  
  instances = var.infra_instance
}

# OCP wildcard SSL Target Pool
resource "google_compute_target_pool" "wildcard-ssl-target-pool" {
  name = "${var.ocp_infra_id}-wildcard-ssl-target-pool"
  
  instances = var.infra_instance
}

# OCP Wildcard Forwarding Rule
resource "google_compute_forwarding_rule" "wildcard-forwarding-rule" {
  name = "${var.ocp_infra_id}-wildcard-forwarding-rule"

  ip_address = google_compute_address.wildcard-public-ip.address
  target = google_compute_target_pool.wildcard-target-pool.id
  port_range = 80
}

# OCP Wildcard SSL Forwarding Rule
resource "google_compute_forwarding_rule" "wildcard-ssl-forwarding-rule" {
  name = "${var.ocp_infra_id}-wildcard-ssl-forwarding-rule"

  ip_address = google_compute_address.wildcard-public-ip.address
  target = google_compute_target_pool.wildcard-ssl-target-pool.id
  port_range = 443
}
