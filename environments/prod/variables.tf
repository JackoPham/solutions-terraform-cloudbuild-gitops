# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "project_id" {
  type = string
  description = "The ID of the project to create resources in"
  default = "tuna-practice"
}

variable "region" {
  type = string
  description = "The region to use"
  default = "asia-southeast1"
}

variable "main_zone" {
  type = string
  description = "The zone to use as primary"
  default = "asia-southeast1-a"
}

variable "cluster_name" {
  default = "tuna-cluster"
}


# variable "cluster_node_zones" {
#   type = list(string)
#   description = "The zones where Kubernetes cluster worker nodes should be located"
#   default = "asia-southeast1-a"
# }

# variable "credentials_file_path" {
#   type = string
#   description = "The credentials JSON file used to authenticate with GCP"
# }

# variable "service_account" {
#   type = string
#   description = "The GCP service account"
# }