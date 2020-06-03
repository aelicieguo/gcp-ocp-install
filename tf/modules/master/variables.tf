variable "ocp_infra_id" {
  type = string
}

variable "ocp_cluster_name" {
  type = string
}

variable "ocp_base_domain" {
  type = string
}

variable "gcp_availability_zones" {
  type = list
}

variable "gcp_master_subnet" {
  type = string
}

variable "gcp_master_count" {
  type = string
}

variable "gcp_master_ip" {
  type = list
}

variable "gcp_master_machine_type" {
  type = string
}

variable "gcp_master_root_volume_size" {
  type = string
}

variable "master_ign" {
  type = string
}

variable "rhcos_image" {
  type = string
}

variable "master_sa" {
  type = string
}
