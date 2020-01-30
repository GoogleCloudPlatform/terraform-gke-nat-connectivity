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


resource "google_container_cluster" "cluster1" {
  name               = "cluster1"
  location           = "${var.zone}"
  initial_node_count = 3
  project            = "${google_project.ivpc.project_id}"
  network            = "${google_compute_network.ivpc.self_link}"
  subnetwork         = "${google_compute_subnetwork.ivpc.self_link}"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-cidr"
    services_secondary_range_name = "service-cidr"
  }
 

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username         = ""
    password         = ""
  }

  node_config {
    oauth_scopes     = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata {
      disable-legacy-endpoints = "true"
    }

    labels = {
      run  = "my-app"
    }

    tags   = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr", 
    "ivpc-allocated-ilb-route"
    ]
  }

  depends_on = [
    # The project APIs services must be set up before the
    # cluster is created or the API call fails.
    "google_project_service.ivpc_container",
    "google_project_service.ivpc_container_registry",
    #"google_project_services.ivpc",
    "google_compute_instance.isolated-vpc-gw",
  ]

  timeouts {
    create = "30m"
    update = "40m"
  }
}

