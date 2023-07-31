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


locals {
  env = "prod"
}

provider "google" {
  // Only needed if you use a service account key
  # credentials = file(var.credentials_file_path)

  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

resource "google_project_service" "service" {
    for_each = toset([
        # "artifactregistry.googleapis.com",
        "compute.googleapis.com",
        "container.googleapis.com"
    ])

    service = each.key

    project            = var.project_id
    disable_on_destroy = false
}

module "google_networks" {
  source = "../../modules/prod/networks"

  project_id = var.project_id
  region     = var.region
}

module "bastion" {
  source = "../../modules/prod/bastion"

  project_id   = var.project_id
  region       = var.region
  zone         = var.main_zone
  bastion_name = "tuna"
  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name
}

module "google_kubernetes_cluster" {
  source = "../../modules/prod/kubernetes_cluster"

  project_id                 = var.project_id
  region                     = var.region
  main_zone                  = var.main_zone
  # node_zones                 = var.cluster_node_zones
  # service_account            = var.service_account
  network_name               = module.google_networks.network.name
  subnet_name                = module.google_networks.subnet.name
  master_ipv4_cidr_block     = module.google_networks.cluster_master_ip_cidr_range
  pods_ipv4_cidr_block       = module.google_networks.cluster_pods_ip_cidr_range
  services_ipv4_cidr_block   = module.google_networks.cluster_services_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32"
}

resource "google_project_iam_member" "bastion-iam" {
  for_each = toset([
    "roles/container.admin",
    "roles/source.admin",
  ])
  role = each.key
  project = var.project_id
  member  = "serviceAccount:${module.bastion.name}-sa@${var.project_id}.iam.gserviceaccount.com"
}