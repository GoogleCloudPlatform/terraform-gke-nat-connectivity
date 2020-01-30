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



resource "google_compute_firewall" "allow-rfc1918-in-ivpc" {
  name          = "allow-rfc1918-in-fwr"
  network       = "${google_compute_network.ivpc.name}"
  project       = "${google_project.ivpc.project_id}"
  target_tags   = ["allow-rfc1918-in-fwr"]

  source_ranges = [
    "10.0.0.0/8", 
    "172.16.0.0/12", 
    "192.168.0.0/16",
  ]

  allow {
    protocol    = "all"
  }
}

resource "google_compute_firewall" "allow-ssh-in-ivpc" {
  name          = "allow-ssh-in-fwr"
  network       = "${google_compute_network.ivpc.name}"
  project       = "${google_project.ivpc.project_id}"  
  target_tags   = ["allow-ssh-in-fwr"]

  allow {
    protocol    = "tcp"
    ports       = ["22",]
  }
}

