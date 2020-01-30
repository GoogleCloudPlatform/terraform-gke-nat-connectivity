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


# ************* [ Isolated VPC gateway. ] *************
# *****************************************************
resource "google_compute_instance" "isolated-vpc-gw" {
  name                      = "isolated-vpc-gw"
  machine_type              = "n1-standard-1"
  zone                      = "${var.zone}"
  project                   = "${google_project.ivpc.project_id}" 
  #project                   = "${var.isolated_vpc_pid}"
  allow_stopping_for_update = "true"
  can_ip_forward            = "true"

  depends_on = [
    # The serviceProjectAdmin policy must be set up before the
    # isolated-vpc gateway in created or the second NIC will not
    # be available to the gce vm.
    "google_project_iam_binding.service_project_admin",
    "google_compute_shared_vpc_host_project.host",
    "google_compute_shared_vpc_service_project.ivpc",
  ]

  metadata_startup_script   = "${var.masquerade == "true" ? "${local.masq}" : "${local.snat}"}"

  tags         = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr",
    #"ivpc-allocated-ilb-route",
  ]

  boot_disk {
    initialize_params {
      image    = "debian-cloud/debian-9"
    }
  }

    network_interface {
    subnetwork = "${google_compute_subnetwork.svpc.self_link}"
    network_ip = "${var.isolated_vpc_gw_host_nic_ip}"
    access_config {
      // Ephemeral IP
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.ivpc.self_link}"
    network_ip = "${var.isolated_vpc_gw_service_nic_ip}"
  }
  service_account {
    scopes     = [
      "service-management",
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring-write",
      "service-control",
    ]
  }
}


# ******************** [ Test machines. ] *******************
# There are three test machines that are used to test the NAT
# configuration of the isolated-vpc gateway. All three test 
# VMs & subnetworks reside in the VPC in the host project.
# ***********************************************************
resource "google_compute_instance" "test1" {
  name                      = "test-10-11-vm"
  machine_type              = "n1-standard-1"
  zone                      = "${var.zone}"
  allow_stopping_for_update = "true"
  project                   = "${google_project.svpc.project_id}"

  tags = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr", 
    "ivpc-allocated-ilb-route"
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.test_net_1.self_link}"
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

resource "google_compute_instance" "test2" {
  name                      = "test-10-160-11-vm"
  machine_type              = "n1-standard-1"
  zone                      = "${var.zone}"
  allow_stopping_for_update = "true"
  project                   = "${google_project.svpc.project_id}"

  tags = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr", 
    "ivpc-allocated-ilb-route"
  ]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.test_net_2.self_link}"
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

resource "google_compute_instance" "test3" {
  name                      = "test-10-64-19-vm"
  machine_type              = "n1-standard-1"
  zone                      = "${var.zone}"
  allow_stopping_for_update = "true"
  project                   = "${google_project.svpc.project_id}"

  tags = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr", 
    "ivpc-allocated-ilb-route"
  ]
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = "${google_compute_subnetwork.test_net_3.self_link}"
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
