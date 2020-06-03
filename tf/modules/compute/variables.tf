variable "ocp_infra_id" {
  type = string
}

variable "ocp_cluster_name" {
  type = string
}

variable "ocp_base_domain" {
  type = string
}

variable "gcp_compute_count" {
  type = string
}

variable "gcp_compute_ip" {
  type = list
}

variable "gcp_availability_zones" {
  type = list
}

variable "gcp_compute_machine_type" {
  type = string
}

variable "gcp_compute_root_volume_size" {
  type = string
}

variable "compute_ign" {
  type = string
}

variable "rhcos_image" {
  type = string
}

variable "compute_sa" {
  type = string
}
