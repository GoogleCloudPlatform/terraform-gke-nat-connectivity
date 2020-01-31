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
  Configure Isolated VPC network
 *****************************************/
resource "google_compute_network" "ivpc" {
  name                    = "ivpc"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = "${google_project.ivpc.project_id}"

  depends_on = [
    # The project's services must be set up before the
    # network is enabled as the compute API will not
    # be enabled and cause the setup to fail.
    "google_project_service.ivpc_service_networking",
    "google_project_service.ivpc_compute"
  ]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

/******************************************
  Configure Isolated VPC subnetworks
 *****************************************/
resource "google_compute_subnetwork" "cluster" {
  name          = "node-cidr"
  ip_cidr_range = "${var.node_cidr}"
  project       = "${google_project.ivpc.project_id}"
  network       = "${google_compute_network.ivpc.self_link}"

  secondary_ip_range {
    range_name    = "pod-cidr"
    ip_cidr_range = "${var.pod_cidr}"
  }

  secondary_ip_range {
    range_name    = "service-cidr"
    ip_cidr_range = "${var.cluster_cidr}"
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "on_prem" {
  name          = "simulated-on-prem"
  ip_cidr_range = "${var.on_prem_cidr}"
  project       = "${google_project.ivpc.project_id}"
  network       = "${google_compute_network.ivpc.self_link}"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}


