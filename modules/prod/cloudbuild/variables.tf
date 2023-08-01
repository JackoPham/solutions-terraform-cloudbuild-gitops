variable "project_id" {
  type = string
  description = "The project ID to host the network in"
}

variable "project_number" {
  type = string
}

variable "region" {
  type = string
  description = "The region to use"
}

variable "main_zone" {
  type = string
  description = "The zone to use as primary"
}

variable "gke_namespace" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "trigger_name" {
  type = string
}


variable "github_repository" {
  type = string
}

variable "bastion" {
  type = string
}

variable "build_file_name" {
  type = string
  default = "cloudbuild.yaml"
}

variable "github_owner" {
  type = string
}

variable "github_branch" {
  type = string
}