# Public DNS Zone
resource "google_dns_managed_zone" "public-zone" {
  name = "${var.ocp_infra_id}-public-zone"
  dns_name = "${var.ocp_base_domain}."
}

# Private DNS Zone
resource "google_dns_managed_zone" "private-zone" {
  provider = google-beta
  name = "${var.ocp_infra_id}-private-zone"
  dns_name = "${var.ocp_cluster_name}.${var.ocp_base_domain}."
  visibility = "private"
  private_visibility_config {
    networks {
      network_url = var.gcp_network
    }
  }
}

# OCP Wildcard DNS Entry in Public DNS Zone
resource "google_dns_record_set" "public-wildcard" {
  name = "*.apps.${google_dns_managed_zone.public-zone.dns_name}"
  type = "A"
  ttl = 60
  managed_zone = google_dns_managed_zone.public-zone.name
  rrdatas = [var.wildcard_public_ip]
}

# OCP API DNS Entry in Public DNS Zone
resource "google_dns_record_set" "public-api" {
  name = "api.${google_dns_managed_zone.public-zone.dns_name}"
  type = "A"
  ttl = 60
  managed_zone = google_dns_managed_zone.public-zone.name
  rrdatas = [var.cluster_public_ip]
}

# OCP API DNS Entry in Private DNS Zone
resource "google_dns_record_set" "private-api" {
  name = "api.${google_dns_managed_zone.private-zone.dns_name}"
  type = "A"
  ttl = 60
  managed_zone = google_dns_managed_zone.private-zone.name
  rrdatas = [var.cluster_public_ip]
}

# OCP API-INT DNS Entry in Private DNS Zone
resource "google_dns_record_set" "private-api-int" {
  name = "api-int.${google_dns_managed_zone.private-zone.dns_name}"
  type = "A"
  ttl = 60
  managed_zone = google_dns_managed_zone.private-zone.name
  rrdatas = [var.cluster_private_ip]
}

# OCP ETCD DNS Entry in Private DNS Zone
resource "google_dns_record_set" "ocp-etcd" {
  name = "etcd-${count.index}.${google_dns_managed_zone.private-zone.dns_name}"
  type = "A"
  ttl = 60
  managed_zone = google_dns_managed_zone.private-zone.name
  rrdatas = [element(var.gcp_master_ip, count.index)]

  count = var.gcp_master_count
}

## OCP Control Planes DNS Entry in Private DNS Zone
#resource "google_dns_record_set" "master-dns" {
#  name = "${var.ocp_infra_id}-master-${count.index+1}"
#  type = "A"
#  ttl = 60
#  managed_zone = google_dns_managed_zone.private-zone.name
#  rrdatas = [element(var.gcp_master_ip, count.index)]
#
#  count = var.gcp_master_count
#}

## OCP Compute DNS Entry in Private DNS Zone
#resource "google_dns_record_set" "worker-dns" {
#  name = "${var.ocp_infra_id}-compute-${count.index+1}"
#  type = "A"
#  ttl = 60
#  managed_zone = google_dns_managed_zone.private-zone.name
#  rrdatas = [element(var.gcp_compute_ip, count.index)]
#
#  count = var.gcp_compute_count
#}

## OCP Infra DNS Entry in Private DNS Zone
#resource "google_dns_record_set" "infra-dns" {
#  name = "${var.ocp_infra_id}-infra-${count.index+1}"
#  type = "A"
#  ttl = 60
#  managed_zone = google_dns_managed_zone.private-zone.name
#  rrdatas = [element(var.gcp_infra_ip, count.index)]

#  count = var.gcp_infra_count
#}
