# IGN for Compute
data "ignition_config" "compute-ign" {
   append {
    source = var.compute_ign
    verification = ""
  }
}

# IP for Infra
resource "google_compute_address" "infra-ip" {
  name = "${var.ocp_infra_id}-infra-ip-${count.index+1}"
  address = element(var.gcp_infra_ip, count.index)
  address_type = "INTERNAL"
  subnetwork = "${var.ocp_infra_id}-compute-subnet" 
  count = var.gcp_infra_count
}

# Compute Instances
resource "google_compute_instance" "infra-instance" {
  name = "${var.ocp_infra_id}-infra-${count.index+1}"
  machine_type = var.gcp_infra_machine_type
  zone         = element(var.gcp_availability_zones, count.index)

  count = var.gcp_infra_count

  tags = ["${var.ocp_infra_id}-compute"]

  boot_disk {
    initialize_params {
      image = var.rhcos_image
      size = var.gcp_infra_root_volume_size
    }
  }

  network_interface {
    network_ip = google_compute_address.infra-ip[count.index].self_link
    subnetwork = "${var.ocp_infra_id}-compute-subnet" 
  }

  hostname = "${var.ocp_infra_id}-infra-${count.index+1}.${var.ocp_cluster_name}.${var.ocp_base_domain}"

  service_account {
   email = var.compute_sa
   scopes = ["cloud-platform"]
  }

  metadata = {
    user-data = data.ignition_config.compute-ign.rendered
  }
}
