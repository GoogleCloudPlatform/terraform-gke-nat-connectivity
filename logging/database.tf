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
  Configure the Postgres database.
 *****************************************/

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

data "null_data_source" "auth_netw_postgres_allowed" {
  inputs  = {
    name  = "node-cidr"
    value = "${var.node_cidr}"
  }
}

resource "google_sql_database_instance" "master" {
  provider         = "google-beta"
  name             = "master-instance-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_9_6"

  region           = "${var.region}"
  project          = "${module.allnat.ivpc_project}"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled        = "false"
      private_network     = "${module.allnat.ivpc_network}"
      authorized_networks {
        name = "ivpc network"
        value = "10.32.0.0/24"
    }
  }

  depends_on = [
    "module.allnat",
    "google_service_networking_connection.private_vpc_connection",
  ]

}

resource "google_sql_database" "translations" {
  name      = "ulog2"
  instance  = "${google_sql_database_instance.master.name}"
  charset   = "UTF8"

  project   = "${var.isolated_vpc_pid}"
}

resource "random_id" "user-password" {
  keepers = {
    name = "user-password"
  }

  byte_length = 8
  depends_on  = ["google_sql_database_instance.master"]
}

resource "google_sql_user" "users" {
  project    = "${module.allnat.ivpc_project}"
  name       = "${var.db_username}"
  instance   = "${google_sql_database_instance.master.name}"
  password   = "${random_id.user-password.hex}"

  depends_on = [
    "google_project_iam_binding.sql_admin",
  ]
}

provider "postgresql" {
  host            = "${google_sql_database_instance.master.ip_address.0.ip_address}"
  port            = "5432"
  database        = "ulog2"
  username        = "${var.db_username}"
  password        = "${random_id.user-password.hex}"
  connect_timeout = 15
}
