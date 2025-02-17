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
  env = "dev"
}

# Create new storage bucket in the US multi-region
# with standard storage

// Use first to create a new bucket

resource "google_storage_bucket" "static" {
 project=  var.project
 name          = "tuna-tf-bucket"
 location      = "US"
 storage_class = "STANDARD"

 uniform_bucket_level_access = true
}

module "bastion" {
  source  = "../../modules/bastion"
}

//  Unse
# module "vpc" {
#   source  = "../../modules/vpc"
#   project = "${var.project}"
#   env     = "${local.env}"
# }

# module "http_server" {
#   source  = "../../modules/http_server"
#   project = "${var.project}"
#   subnet  = "${module.vpc.subnet}"
# }

# module "firewall" {
#   source  = "../../modules/firewall"
#   project = "${var.project}"
#   subnet  = "${module.vpc.subnet}"
# }
