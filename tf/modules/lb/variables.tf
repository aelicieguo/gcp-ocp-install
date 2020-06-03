variable "ocp_infra_id" {
  type = string
}

variable "ocp_ign_ip" {
  type = string
}

variable "ocp_int_ip" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "gcp_network" {
  type = string
}

variable "master_subnet" {
  type = string
}

variable "api_instance" {
  type = list
}

variable "infra_instance" {
  type = list
}
