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


# ************* [ Isolated VPC ] ***************
# **********************************************
resource "google_compute_network" "ivpc" {
  name                    = "${var.isolated_net_name}"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = "${google_project.ivpc.project_id}"

  depends_on = [
    # The project's services must be set up before the
    # network is enabled as the compute API will not
    # be enabled and cause the setup to fail.
    "google_project_service.ivpc_compute",
  ]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "ivpc" {
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
    ip_cidr_range = "${var.service_cidr}"
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }
}


# ************ [ Routed-Domain VPC ] ************
# ***********************************************
resource "google_compute_network" "svpc" {
  name                    = "${var.shared_net_name}"
  auto_create_subnetworks = "false"
  routing_mode            = "GLOBAL"
  project                 = "${google_project.svpc.project_id}"

  depends_on = [
    # The project's services must be set up before the
    # network is enabled as the compute API will not
    # be enabled and cause the setup to fail.
    "google_project_service.svpc_compute",
  ]

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "svpc" {
  name          = "shared-cidr"
  ip_cidr_range = "${var.shared_cidr}"
  project       = "${google_project.svpc.project_id}"
  network       = "${google_compute_network.svpc.self_link}"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "test_net_1" {
  name          = "test-10-11"
  ip_cidr_range = "${var.test1_cidr}"
  project       = "${google_project.svpc.project_id}"
  network       = "${google_compute_network.svpc.self_link}"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "test_net_2" {
  name          = "test-10-160-11"
  ip_cidr_range = "${var.test2_cidr}"
  project       = "${google_project.svpc.project_id}"
  network       = "${google_compute_network.svpc.self_link}"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}

resource "google_compute_subnetwork" "test_net_3" {
  name          = "test-10-64-19"
  ip_cidr_range = "${var.test3_cidr}"
  project       = "${google_project.svpc.project_id}"
  network       = "${google_compute_network.svpc.self_link}"

  timeouts {
    create = "10m"
    delete = "10m"
  }
}


# ********* [ Shared VPC configuration ] *********
# ************************************************
resource "google_compute_shared_vpc_host_project" "host" {
  project = "${google_project.svpc.project_id}"
  depends_on = [
    # The project's services must be set up before the
    # shared VPC is enabled as the compute API will not
    # be enabled and cause the setup to fail.
    #"google_project_services.svpc",
    "google_project_service.svpc_compute",
    "google_project_service.ivpc_service_networking",
  ]
}
resource "google_compute_shared_vpc_service_project" "ivpc" {
  host_project    = "${google_compute_shared_vpc_host_project.host.project}"
  service_project = "${google_project.ivpc.project_id}"
  depends_on = [
    # The project's services must be set up before the
    # shared VPC is enabled as the compute API will not      
    # be enabled and cause the setup to fail.
    "google_project_service.svpc_compute",
    "google_project_service.ivpc_service_networking",
  ]
}
