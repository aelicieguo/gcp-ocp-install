# IAM policy for Control Plane
data "google_iam_policy" "master" {
  binding {
    role = "roles/compute.instanceAdmin"

    members = [
      "serviceAccount:google_service_account.master-sa.name",
    ]
  }
  binding {
    role = "roles/compute.networkAdmin"

    members = [
      "serviceAccount:google_service_account.master-sa.name",
    ]
  }
  binding {
    role = "roles/compute.securityAdmin"

    members = [
      "serviceAccount:google_service_account.master-sa.name",
    ]
  }
  binding {
    role = "roles/compute.serviceAccountUser"

    members = [
      "serviceAccount:google_service_account.master-sa.name",
    ]
  }
  binding {
    role = "roles/compute.storageAdmin"

    members = [
      "serviceAccount:google_service_account.master-sa.name",
    ]
  }
}

# IAM policy for Compute
data "google_iam_policy" "compute" {
  binding {
    role = "roles/compute.viewer"

    members = [
      "serviceAccount:google_service_account.compute-sa.name",
    ]
  }
  binding {
    role = "roles/compute.storageAdmin"

    members = [
      "serviceAccount:google_service_account.compute-sa.name",
    ]
  }
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

## Permission for Worker Service Account
#resource "google_service_account_iam_policy" "compute-sa-iam" {
#  service_account_id = google_service_account.compute-sa.name
#  policy_data = data.google_iam_policy.compute.policy_data
#}
