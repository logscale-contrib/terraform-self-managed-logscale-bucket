
variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  description = "cluster name"
}

variable "region" {
  description = "The region to host the cluster in"
}

variable "namespace" {
  type = string
  description = "(optional) describe your variable"
}

variable "sa" {
  type = string
  description = "(optional) describe your variable"
}