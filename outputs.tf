output "bucket_name" {
    value = module.gcs_buckets.name
}

output "iam_email" {
    value = module.bucket_sa.iam_email
}