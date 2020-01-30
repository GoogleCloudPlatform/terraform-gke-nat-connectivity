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


# *************** [ Routed-domain routes ] ****************
# *********************************************************
resource "google_compute_route" "ivpc-allocated-ilb-route" {
  name        = "ivpc-allocated-ilb-route"
  project     = "${google_project.svpc.project_id}"
  dest_range  = "${var.ilb_cidr}"
  network     = "${google_compute_network.svpc.self_link}"
  next_hop_ip = "${var.isolated_vpc_gw_host_nic_ip}"
  description = "Routed-domain route that directs traffic to ilb."

  depends_on = [
    # The isolated-vpc gateway and subnets must be set up before the
    # routes as we need the CIDR blocks in the subnets and the 
    # next-hop IP address to exist before routes are created.
    "google_compute_instance.isolated-vpc-gw",
    "google_compute_subnetwork.svpc",
  ]

  tags = [
    "ivpc-allocated-ilb-route",
  ]
}


# *************** [ Isolated-vpc routes ] *****************
# *********************************************************
resource "google_compute_route" "ivpc-to-10net" {
  name        = "ivpc-to-10net"
  project     = "${google_project.ivpc.project_id}"
  dest_range  = "10.0.0.0/8"
  network     = "${google_compute_network.ivpc.self_link}"
  next_hop_ip = "${var.isolated_vpc_gw_service_nic_ip}"
  description = "Isolated-vpc route that directs traffic to on-prem network."

  depends_on = [
    # The isolated-vpc gateway and subnets must be set up before the
    # routes as we need the CIDR blocks in the subnets and the
    # next-hop IP address to exist before routes are created.
    "google_compute_instance.isolated-vpc-gw",
    "google_compute_subnetwork.ivpc",  
  ]

  tags = [
    "routed-domain-rfc1918-route",
  ]
}

resource "google_compute_route" "ivpc-to-172-16net" {
  name        = "ivpc-to-172-16net"
  project     = "${google_project.ivpc.project_id}"
  dest_range  = "172.16.0.0/12"
  network     = "${google_compute_network.ivpc.self_link}"
  next_hop_ip = "${var.isolated_vpc_gw_service_nic_ip}"
  description = "Isolated-vpc route that directs traffic to on-prem network."

  depends_on = [
    # The isolated-vpc gateway and subnets must be set up before the
    # routes as we need the CIDR blocks in the subnets and the
    # next-hop IP address to exist before routes are created.
    "google_compute_instance.isolated-vpc-gw",
    "google_compute_subnetwork.ivpc",  
  ]

  tags = [
    "routed-domain-rfc1918-route",
  ]
}

resource "google_compute_route" "ivpc-to-192-168net" {
  name        = "ivpc-to-192-168net"
  project     = "${google_project.ivpc.project_id}"
  dest_range  = "192.168.0.0/16"
  network     = "${google_compute_network.ivpc.self_link}"
  next_hop_ip = "${var.isolated_vpc_gw_service_nic_ip}"
  description = "Isolated-vpc route that directs traffic to on-prem network."

  depends_on = [
    # The isolated-vpc gateway and subnets must be set up before the
    # routes as we need the CIDR blocks in the subnets and the
    # next-hop IP address to exist before routes are created.
    "google_compute_instance.isolated-vpc-gw",
    "google_compute_subnetwork.ivpc",  
  ]

  tags = [
    "routed-domain-rfc1918-route",
  ]
}

