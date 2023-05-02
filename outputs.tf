output "bucket_name" {
  value = module.gcs_buckets.name
}
output "iam_sa" {
  value = module.wi.gcp_service_account
}
output "iam_email" {
  value = module.wi.gcp_service_account_email
}
