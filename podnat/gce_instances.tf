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



resource "google_compute_instance" "simulated_on_prem_host" {
  name                      = "simulated-on-prem-host"
  machine_type              = "n1-standard-1"
  zone                      = "${var.zone}"
  allow_stopping_for_update = "true"
  project                   = "${google_project.ivpc.project_id}"

  metadata_startup_script   = "#! /bin/bash; sudo apt-get -y install tcpdump"

  tags = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr",
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.on_prem.self_link}"
    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = [
      "service-management",
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring-write",
      "service-control",
    ]
  }
}

