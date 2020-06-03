# IGN for Control Plane
data "ignition_config" "master-ign" {
   append {
    source = var.master_ign
    verification = ""
  }
}

# IP for Control Planes
resource "google_compute_address" "master-ip" {
  name = "${var.ocp_infra_id}-master-ip-${count.index+1}"
  address = element(var.gcp_master_ip, count.index)
  address_type = "INTERNAL"
  subnetwork = "${var.ocp_infra_id}-master-subnet" 
  count = var.gcp_master_count
}

# Control Plane Instances
resource "google_compute_instance" "master-instance" {
  name = "${var.ocp_infra_id}-master-${count.index+1}"
  machine_type = var.gcp_master_machine_type
  zone         = element(var.gcp_availability_zones, count.index)

  count = var.gcp_master_count

  tags = ["${var.ocp_infra_id}-master"]

  boot_disk {
    initialize_params {
      image = var.rhcos_image
      size = var.gcp_master_root_volume_size
    }
  }

  network_interface {
    network_ip = google_compute_address.master-ip[count.index].self_link
    subnetwork = "${var.ocp_infra_id}-master-subnet" 
  }

  hostname = "${var.ocp_infra_id}-master-${count.index+1}.${var.ocp_cluster_name}.${var.ocp_base_domain}"

  service_account {
   email = var.master_sa
   scopes = ["cloud-platform"]
  }

  metadata = {
    user-data = data.ignition_config.master-ign.rendered
  }
}
