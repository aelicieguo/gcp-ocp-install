# OCP API LB Frontend Public IP
resource "google_compute_address" "ocp-api-public-ip" {
  name = "${var.ocp_infra_id}-ocp-api-public-ip"
}

# OCP API Target Pool
resource "google_compute_target_pool" "ocp-api-target-pool" {
  name = "${var.ocp_infra_id}-ocp-api-target-pool"
  
  instances = var.api_instance
}

# OCP API Forwarding Rule
resource "google_compute_forwarding_rule" "ocp-api-forwarding-rule" {
  name = "${var.ocp_infra_id}-ocp-api-forwarding-rule"

  ip_address = google_compute_address.ocp-api-public-ip.address
  target = google_compute_target_pool.ocp-api-target-pool.id
  port_range = 6443
}

# OCP API-INT LB Frontend IGN Private IP
resource "google_compute_address" "ocp-ign-private-ip" {
  name = "${var.ocp_infra_id}-ocp-ign-private-ip"
  region = var.gcp_region
  subnetwork = var.master_subnet
  address_type = "INTERNAL"
  address = var.ocp_ign_ip
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
  name = "${var.ocp_infra_id}-ign-forwarding-rule"
  region = var.gcp_region

  load_balancing_scheme = "INTERNAL"

  ip_address = google_compute_address.ocp-ign-private-ip.address
  backend_service = google_compute_region_backend_service.ign-backend.id
  network = var.gcp_network
  subnetwork = var.master_subnet

  ports = ["22623"]
}

# OCP API-INT LB Frontend API Private IP
resource "google_compute_address" "ocp-api-private-ip" {
  name = "${var.ocp_infra_id}-ocp-api-private-ip"
  region = var.gcp_region
  subnetwork = var.master_subnet
  address_type = "INTERNAL"
  address = var.ocp_int_ip
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

  ip_address = google_compute_address.ocp-api-private-ip.address
  backend_service = google_compute_region_backend_service.api-int-backend.id
  network = var.gcp_network
  subnetwork = var.master_subnet

  ports = ["6443"]
}

# OCP Wildcard LB Frontend Public IP
resource "google_compute_address" "wildcard-public-ip" {
  name = "${var.ocp_infra_id}-wildcard-public-ip"
}

# OCP Wildcard Target Pool
resource "google_compute_target_pool" "wildcard-target-pool" {
  name = "${var.ocp_infra_id}-wildcard-target-pool"
  
  instances = var.infra_instance
}

# OCP Wildcard Forwarding Rule
resource "google_compute_forwarding_rule" "wildcard-forwarding-rule" {
  name = "${var.ocp_infra_id}-wildcard-forwarding-rule"

  ip_address = google_compute_address.wildcard-public-ip.address
  target = google_compute_target_pool.wildcard-target-pool.id
  port_range = 80
}

# OCP SSL Wildcard LB Frontend Public IP
resource "google_compute_address" "ssl-wildcard-public-ip" {
  name = "${var.ocp_infra_id}-ssl-wildcard-public-ip"
}

# OCP SSL Wildcard Target Pool
resource "google_compute_target_pool" "ssl-wildcard-target-pool" {
  name = "${var.ocp_infra_id}-ssl-wildcard-target-pool"
  
  instances = var.infra_instance
}

# OCP SSL Wildcard Forwarding Rule
resource "google_compute_forwarding_rule" "ssl-wildcard-forwarding-rule" {
  name = "${var.ocp_infra_id}-ssl-wildcard-forwarding-rule"

  ip_address = google_compute_address.ssl-wildcard-public-ip.address
  target = google_compute_target_pool.ssl-wildcard-target-pool.id
  port_range = 443
}
