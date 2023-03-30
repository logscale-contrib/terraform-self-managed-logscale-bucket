module "bucket_sa" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 4.0"
  project_id   = var.project_id
  prefix       = var.cluster_name
  names        = [format("%s-%s", var.namespace, var.sa)]
  display_name = var.cluster_name
  description  = var.cluster_name
}
module "iam" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "7.5.0"

  project = var.project_id

  service_accounts = [
    module.bucket_sa.email
  ]
  mode = "authoritative"

  bindings = {
    "roles/iam.workloadIdentityUser" = [
      format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, var.namespace, var.sa)
    ]
  }
}

resource "google_service_account_key" "service_account" {
  service_account_id = module.bucket_sa.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

module "gcs_buckets" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 3.4"
  project_id      = var.project_id
  names           = [format("%s-%s", var.namespace, var.sa)]
  prefix          = var.cluster_name
  set_admin_roles = true
  versioning = {
    first = true
  }
  bucket_admins = {
    ls = module.bucket_sa.iam_email
  }
}
