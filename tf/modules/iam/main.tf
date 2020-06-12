# IAM policy for Control Plane
#data "google_iam_policy" "master" {
#  binding {
#    role = "roles/compute.instanceAdmin"
#
#    members = [
#      "serviceAccount:${google_service_account.master-sa.email}",
#    ]
#  }
#  binding {
#    role = "roles/compute.networkAdmin"
#
#    members = [
#      "serviceAccount:${google_service_account.master-sa.email}",
#    ]
#  }
#  binding {
#    role = "roles/compute.securityAdmin"
#
#    members = [
#      "serviceAccount:${google_service_account.master-sa.email}",
#    ]
#  }
#  binding {
#    role = "roles/compute.serviceAccountUser"
#
#    members = [
#      "serviceAccount:${google_service_account.master-sa.email}",
#   ]
# }
# binding {
#   role = "roles/compute.storageAdmin"
#
#   members = [
#     "serviceAccount:${google_service_account.master-sa.email}",
#   ]
# }
#}

## IAM policy for Compute
#data "google_iam_policy" "compute" {
# binding {
#   role = "roles/compute.viewer"
#
#   members = [
#     "serviceAccount:${google_service_account.compute-sa.email}",
#   ]
# }
# binding {
#   role = "roles/compute.storageAdmin"
#
#   members = [
#     "serviceAccount:${google_service_account.compute-sa.email}",
#   ]
# }
#}

# Bind compute instance admin to master sa 
resource "google_project_iam_binding" "master-instance-admin" {
#  service_account_id = google_service_account.master-sa.name
  role = "roles/compute.instanceAdmin"
  members = [
    "serviceAccount:${google_service_account.master-sa.email}",
  ]
}

# Bind compute network admin to master sa 
resource "google_project_iam_binding" "master-network-admin" {
#  service_account_id = google_service_account.master-sa.name
  role = "roles/compute.networkAdmin"
  members = [
    "serviceAccount:${google_service_account.master-sa.email}",
  ]
}

# Bind compute security admin to master sa 
resource "google_project_iam_binding" "master-security-admin" {
#  service_account_id = google_service_account.master-sa.name
  role = "roles/compute.securityAdmin"
  members = [
    "serviceAccount:${google_service_account.master-sa.email}",
  ]
}

# Bind compute sa user to master sa 
resource "google_project_iam_binding" "master-sa-user" {
#  service_account_id = google_service_account.master-sa.name
  role = "roles/iam.serviceAccountUser"
  members = [
    "serviceAccount:${google_service_account.master-sa.email}",
  ]
}

# Bind compute storage admin to master sa 
resource "google_project_iam_binding" "master-storage-admin" {
#  service_account_id = google_service_account.master-sa.name
  role = "roles/compute.storageAdmin"
  members = [
    "serviceAccount:${google_service_account.master-sa.email}",
  ]
}

# Bind compute viewer to compute sa 
resource "google_project_iam_binding" "compute-viewer" {
#  service_account_id = google_service_account.compute-sa.name
  role = "roles/compute.viewer"
  members = [
    "serviceAccount:${google_service_account.compute-sa.email}",
  ]
}

# Bind compute storage admin to compute sa 
resource "google_project_iam_binding" "compute-storage-admin" {
#  service_account_id = google_service_account.compute-sa.name
  role = "roles/compute.storageAdmin"
  members = [
    "serviceAccount:${google_service_account.compute-sa.email}",
  ]
}

# Control Plane Service Account
resource "google_service_account" "master-sa" {
  account_id = "${var.ocp_infra_id}-master"
  display_name = "${var.ocp_infra_id}-master"
}

# Worker Service Account
resource "google_service_account" "compute-sa" {
  account_id = "${var.ocp_infra_id}-compute"
  display_name = "${var.ocp_infra_id}-compute"
}

## Permission for Control Plane Service Account
#resource "google_service_account_iam_policy" "master-sa-iam" {
#  service_account_id = google_service_account.master-sa.name
#  policy_data = data.google_iam_policy.master.policy_data
#}

## Permission for Compute Service Account
#resource "google_service_account_iam_policy" "compute-sa-iam" {
#  service_account_id = google_service_account.compute-sa.name
#  policy_data = data.google_iam_policy.compute.policy_data
#}
