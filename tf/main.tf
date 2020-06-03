terraform {
  required_version = ">=0.12.24"
}

provider "google" {
   credentials = file("ocp-dev-optical-mode-277107.json")
   project = var.gcp_project_id
   region  = var.gcp_region
}

module "vpc" {
  source = "./modules/vpc"
  ocp_infra_id = var.ocp_infra_id
  gcp_region = var.gcp_region
  gcp_master_subnet = var.gcp_master_subnet
  gcp_compute_subnet = var.gcp_compute_subnet
}

module "lb" {
  source = "./modules/lb"
  ocp_infra_id = var.ocp_infra_id
  ocp_ign_ip = var.ocp_ign_ip
  ocp_int_ip = var.ocp_int_ip
  gcp_region = var.gcp_region
  gcp_network = module.vpc.gcp_network.self_link
  master_subnet = module.vpc.master_subnet.self_link
  api_instance = concat(module.bootstrap.bootstrap_instance.*.self_link, module.master.master_instance.*.self_link)
  infra_instance = module.infra.infra_instance.*.self_link
}

module "dns" {
  source = "./modules/dns"
  ocp_base_domain = var.ocp_base_domain
  ocp_infra_id = var.ocp_infra_id
  ocp_cluster_name = var.ocp_cluster_name
  gcp_master_count = var.gcp_master_count
  ocp_ign_ip = var.ocp_ign_ip
  ocp_int_ip = var.ocp_int_ip
  gcp_bootstrap_ip = var.gcp_bootstrap_ip
  gcp_master_ip = var.gcp_master_ip
  gcp_compute_count = var.gcp_compute_count
  gcp_compute_ip = var.gcp_compute_ip
  gcp_infra_count = var.gcp_infra_count
  gcp_infra_ip = var.gcp_infra_ip
  gcp_network = module.vpc.gcp_network.self_link
  ocp_api_public_ip = module.lb.ocp_api_public_ip.address
  wildcard_public_ip = module.lb.wildcard_public_ip.address
  ssl_wildcard_public_ip = module.lb.ssl_wildcard_public_ip.address
}

module "firewall" {
  source = "./modules/firewall"
  ocp_infra_id = var.ocp_infra_id
  gcp_cluster_network_cidr = var.gcp_cluster_network_cidr
  gcp_master_subnet = var.gcp_master_subnet
  gcp_compute_subnet = var.gcp_compute_subnet
  gcp_network = module.vpc.gcp_network.self_link
  ocp_int_ip = var.ocp_int_ip
}

module "iam" {
  source = "./modules/iam"
  gcp_project_id = var.gcp_project_id
  ocp_infra_id = var.ocp_infra_id
}

module "rhcos" {
  source = "./modules/rhcos"
  ocp_infra_id = var.ocp_infra_id
  ocp_cluster_name = var.ocp_cluster_name
  gcp_location = var.gcp_region
}

module "bootstrap" {
  source = "./modules/bootstrap"
  ocp_infra_id = var.ocp_infra_id
  gcp_bootstrap_machine_type = var.gcp_bootstrap_machine_type
  gcp_bootstrap_ip = var.gcp_bootstrap_ip
  gcp_availability_zones = var.gcp_availability_zones
  gcp_bootstrap_root_volume_size = var.gcp_bootstrap_root_volume_size
  bootstrap_ign = module.rhcos.bootstrap_ign.self_link
  gcp_network = module.vpc.gcp_network.self_link
  rhcos_image = module.rhcos.rhcos_image.self_link
  master_subnet = module.vpc.master_subnet.name
}

module "master" {
  source = "./modules/master"
  ocp_infra_id = var.ocp_infra_id
  ocp_base_domain = var.ocp_base_domain
  ocp_cluster_name = var.ocp_cluster_name
  gcp_master_subnet = var.gcp_master_subnet
  gcp_master_machine_type = var.gcp_master_machine_type
  gcp_availability_zones = var.gcp_availability_zones
  gcp_master_count = var.gcp_master_count
  gcp_master_ip = var.gcp_master_ip
  gcp_master_root_volume_size = var.gcp_master_root_volume_size
  master_ign = module.rhcos.master_ign.self_link
  rhcos_image = module.rhcos.rhcos_image.self_link
  master_sa = module.iam.master_sa.email
}

module "compute" {
  source = "./modules/compute"
  ocp_infra_id = var.ocp_infra_id
  ocp_base_domain = var.ocp_base_domain
  ocp_cluster_name = var.ocp_cluster_name
  gcp_compute_machine_type = var.gcp_compute_machine_type
  gcp_availability_zones = var.gcp_availability_zones
  gcp_compute_count = var.gcp_compute_count
  gcp_compute_ip = var.gcp_compute_ip
  gcp_compute_root_volume_size = var.gcp_compute_root_volume_size
  compute_ign = module.rhcos.compute_ign.self_link
  rhcos_image = module.rhcos.rhcos_image.self_link
  compute_sa = module.iam.compute_sa.email
}

module "infra" {
  source = "./modules/infra"
  ocp_infra_id = var.ocp_infra_id
  ocp_base_domain = var.ocp_base_domain
  ocp_cluster_name = var.ocp_cluster_name
  gcp_infra_machine_type = var.gcp_infra_machine_type
  gcp_availability_zones = var.gcp_availability_zones
  gcp_infra_count = var.gcp_infra_count
  gcp_infra_ip = var.gcp_infra_ip
  gcp_infra_root_volume_size = var.gcp_infra_root_volume_size
  compute_ign = module.rhcos.compute_ign.self_link
  rhcos_image = module.rhcos.rhcos_image.self_link
  compute_sa = module.iam.compute_sa.email
}
