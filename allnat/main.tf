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


provider "google" {
  version = "2.20.1"
  region  = "${var.region}"
  zone    = "${var.zone}"
}

data "google_billing_account" "acct" {
  billing_account = "${var.billing_account}"
  open            = true
}

resource "google_project" "ivpc" {
  name            = "Isolated VPC project"
  project_id      = "${var.isolated_vpc_pid}"
  org_id          = "${var.org_id}"
  billing_account = "${data.google_billing_account.acct.id}"
}

resource "google_project" "svpc" {
  name            = "Shared VPC project"
  project_id      = "${var.shared_vpc_pid}"
  org_id          = "${var.org_id}"
  billing_account = "${data.google_billing_account.acct.id}"
}

locals {
  masq = "${file("${path.module}/masquerade_startup_script.sh")}"
  snat = "${file("${path.module}/snat_startup_script.sh")}"
}

resource "google_project_iam_binding" "service_project_admin" {
  #project = "${var.shared_vpc_pid}"
  project = "${google_project.svpc.project_id}"
  role    = "roles/compute.networkUser"

  members = [
    "user:${var.user_account}",
  ]
}

resource "google_project_service" "ivpc_compute" {
  project   = "${google_project.ivpc.project_id}"
  service   = "compute.googleapis.com"
}

resource "google_project_service" "ivpc_container" {
  project   = "${google_project.ivpc.project_id}"
  service   = "container.googleapis.com" 
}

resource "google_project_service" "ivpc_container_registry" {
  project   = "${google_project.ivpc.project_id}"
  service   = "containerregistry.googleapis.com"
}

resource "google_project_service" "ivpc_service_networking" {
  project   = "${google_project.ivpc.project_id}"
  service   = "servicenetworking.googleapis.com"
}

resource "google_project_service" "ivpc_service_usage" {
  project   = "${google_project.ivpc.project_id}"
  service   = "serviceusage.googleapis.com"
}


resource "google_project_service" "ivpc_sql_component" {
  project   = "${google_project.ivpc.project_id}"
  service   = "sql-component.googleapis.com"
}

resource "google_project_service" "svpc_compute" {
  project   = "${google_project.svpc.project_id}"
  service   = "compute.googleapis.com"

  disable_dependent_services=true
}

resource "google_project_service" "svpc_service_networking" {
  project   = "${google_project.svpc.project_id}"
  service   = "servicenetworking.googleapis.com"
}

resource "google_project_service" "svpc_service_usage" {
  project   = "${google_project.svpc.project_id}"
  service   = "serviceusage.googleapis.com"
}
