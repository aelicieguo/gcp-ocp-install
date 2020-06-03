# Please see the respective sections for variable block for the unique variable names for all GCP components created

####################################################################
# VPC

variable "gcp_project_id" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_availability_zones" {
  type = list
}

variable "ocp_infra_id" {
  type = string
}

variable "gcp_cluster_network_cidr" {
  type = string
}

variable "gcp_master_subnet" {
  type = string
}

variable "gcp_compute_subnet" {
  type = string
}

variable "gcp_master_count" {
  type = string
}

variable "gcp_compute_count" {
  type = string
}

variable "gcp_infra_count" {
  type = string
}

####################################################################
# DNS 

variable "ocp_cluster_name" {
  type = string
}

variable "ocp_base_domain" {
  type = string
}

####################################################################
# BOOTSTRAP

variable "gcp_bootstrap_machine_type" {
  type = string
}

variable "gcp_bootstrap_root_volume_size" {
  type = string
}

####################################################################
# MASTER

variable "gcp_master_machine_type" {
  type = string
}

variable "gcp_master_ip" {
  type = list
}

variable "gcp_master_root_volume_size" {
  type = string
}

####################################################################
# COMPUTE

variable "gcp_compute_machine_type" {
  type = string
}

variable "gcp_compute_ip" {
  type = list
}

variable "gcp_compute_root_volume_size" {
  type = string
}

####################################################################
# INFRA

variable "gcp_infra_machine_type" {
  type = string
}

variable "gcp_infra_ip" {
  type = list
}

variable "gcp_infra_root_volume_size" {
  type = string
}
