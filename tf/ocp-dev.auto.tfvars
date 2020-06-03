####################################################################
# VPC

gcp_project_id = "optical-mode-277107"
#gcp_service_account = "ocp-dev@optical-mode-277107.iam.gserviceaccount.com"
gcp_region = "asia-southeast1"
gcp_availability_zones = ["asia-southeast1-a","asia-southeast1-b","asia-southeast1-c",]
gcp_cluster_network_cidr = "10.0.0.0/16"

####################################################################
# Cluster

ocp_cluster_name = "ocp-dev"
ocp_infra_id = "ocp-de-fqlz9"
ocp_base_domain = "aelicie.xyz"
ocp_int_ip = "10.0.15.10"
ocp_ign_ip = "10.0.15.20"

####################################################################
# Bootstrap

gcp_bootstrap_machine_type = "n1-standard-2"
gcp_bootstrap_root_volume_size = "120"
gcp_bootstrap_ip = "10.0.15.2"

####################################################################
# Control Plane

gcp_master_subnet = "10.0.0.0/19"
gcp_master_count = "3"
gcp_master_ip = ["10.0.10.1","10.0.10.2","10.0.10.3"]
gcp_master_machine_type = "n1-standard-2"
gcp_master_root_volume_size = "80"

####################################################################
# Compute

gcp_compute_subnet = "10.0.32.0/19"
gcp_compute_count = "1"
gcp_compute_ip = ["10.0.40.1"]
gcp_compute_machine_type = "n1-standard-2"
gcp_compute_root_volume_size = "80"

####################################################################
# Infra

gcp_infra_count = "2"
gcp_infra_ip = ["10.0.35.1","10.0.35.2"]
gcp_infra_machine_type = "n1-standard-2"
gcp_infra_root_volume_size = "80"
