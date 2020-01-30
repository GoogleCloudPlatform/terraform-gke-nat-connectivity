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


# Output values needed for the associated logging tutorial solution.

output "ivpc_project" {
  value = "${google_project.ivpc.id}"
}

output "ivpc_network" {
  value = "${google_compute_network.ivpc.self_link}"
}

output "cluster1_endpoint" {
  value = "google_container_cluster.cluster1.endpoint"
}

output "cluster1_certificate" {
  value = "google_container_cluster.cluster1.master_auth.0.cluster_ca_certificate"
}

