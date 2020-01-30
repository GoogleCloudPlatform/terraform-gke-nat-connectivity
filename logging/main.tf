/*
Copyright 2020 Google LLC
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    https://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2020-feb-01' } *-->



/******************************************
  Configure the allnat infrastructure
 *****************************************/
module "allnat" {
  source = "./modules/allnat"

  region                         = "${var.region}"
  zone                           = "${var.zone}"
  test1_cidr                     = "${var.test1_cidr}"
  test2_cidr                     = "${var.test2_cidr}"
  test3_cidr                     = "${var.test3_cidr}"
  billing_account                = "${var.billing_account}"
  shared_vpc_pid                 = "${var.shared_vpc_pid}"
  masquerade                     = "${var.masquerade}"
  user_account                   = "${var.user_account}"
  org_id                         = "${var.org_id}"
  pod_cidr                       = "${var.pod_cidr}"
  service_cidr                   = "${var.service_cidr}"
  shared_net_name                = "${var.shared_net_name}"
  ilb_cidr                       = "${var.ilb_cidr}"
  isolated_vpc_gw_host_nic_ip    = "${var.isolated_vpc_gw_host_nic_ip}"
  shared_cidr                    = "${var.shared_cidr}"
  isolated_vpc_gw_service_nic_ip = "${var.isolated_vpc_gw_service_nic_ip}"
  isolated_vpc_pid               = "${var.isolated_vpc_pid}"
  node_cidr                      = "${var.node_cidr}"
  isolated_net_name              = "${var.isolated_net_name}"
  ilb_ip                         = "${var.ilb_ip}"
}


/******************************************
  Configure providers
 *****************************************/
provider "google" {
  version = "2.5.1"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

provider "google-beta"{
  version  = "2.5.1"
  project  = "${module.allnat.ivpc_project}"
  region   = "${var.region}"
  zone     = "${var.zone}"
}


/******************************************
  Configure iam role
 *****************************************/
resource "google_project_iam_binding" "sql_admin" {
  project = "${module.allnat.ivpc_project}"
  role    = "roles/cloudsql.admin"

  members = [
    "user:${var.user_account}",
  ]
}
