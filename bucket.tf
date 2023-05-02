module "bucket_sa" {
  source       = "terraform-google-modules/service-accounts/google"
  version      = "~> 4.0"
  project_id   = var.project_id
  prefix       = var.cluster_name
  names        = [var.namespace]
  display_name = var.cluster_name
  description  = var.cluster_name
}
module "wi" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = var.sa
  namespace  = var.namespace
  project_id = var.project_id
  roles      = ["roles/storage.admin", "roles/compute.admin"]
}

module "gcs_buckets" {
  source          = "terraform-google-modules/cloud-storage/google"
  version         = "~> 3.4"
  project_id      = var.project_id
  location        = var.region
  names           = [format("%s-%s", var.namespace, var.sa)]
  prefix          = var.cluster_name
  set_admin_roles = true
  versioning = {
    first = true
  }
  bucket_admins = {
    ls = module.wi.gcp_service_account
  }
}
