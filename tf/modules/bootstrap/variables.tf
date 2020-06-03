variable "gcp_availability_zones" {
  type = list
}

variable "ocp_infra_id" {
  type = string
}

variable "gcp_bootstrap_machine_type" {
  type = string
}

variable "gcp_bootstrap_root_volume_size" {
  type = string
}

variable "bootstrap_ign" {
  type = string
}

variable "gcp_network" {
  type = string
}

variable "rhcos_image" {
  type = string
}

variable "master_subnet" {
  type = string
}
