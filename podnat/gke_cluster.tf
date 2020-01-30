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
  Create cluster
 *****************************************/
resource "google_container_cluster" "cluster1" {
  name               = "cluster1"
  location           = "${var.zone}"
  initial_node_count = 3
  project            = "${google_project.ivpc.project_id}"
  network            = "${google_compute_network.ivpc.self_link}"
  subnetwork         = "${google_compute_subnetwork.cluster.self_link}"

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-cidr"
    services_secondary_range_name = "service-cidr"
  }
 
  addons_config {
    network_policy_config {
      disabled = "false"
    }
  }

  # Setting an empty username and password explicitly disables basic auth
  master_auth {
    username = ""
    password = ""
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      run  = "my-app",
      maintained_by = "terraform",
    }

    tags   = [
    "allow-rfc1918-in-fwr",
    "allow-ssh-in-fwr",
    ]
  }

  depends_on = [
    # The project APIs services must be set up before the
    # cluster is created or the API call fails.
    "google_project_service.ivpc_service_networking",
  ]

  timeouts {
    create = "30m"
    update = "40m"
  }
}



/******************************************
  Credential setup
 *****************************************/
data "google_client_config" "default" {}

provider "kubernetes" {
  load_config_file = false


  #username = "${var.gcp_user}"
  #password = "${var.cluster_password}"
  host = "https://${google_container_cluster.cluster1.endpoint}"
  token = "${data.google_client_config.default.access_token}"
  cluster_ca_certificate = "${base64decode(google_container_cluster.cluster1.master_auth.0.cluster_ca_certificate)}"
}



/******************************************
  Create ip-masq-agent confimap
 *****************************************/
resource "kubernetes_config_map" "ip-masq-agent" {

  metadata {
    name      = "ip-masq-agent"
    namespace = "kube-system"

    labels = {
      maintained_by = "terraform"
    }
  }

  data = {
    config = <<EOF
nonMasqueradeCIDRs:
  - ${join("\n  - ", var.non_masquerade_cidrs)}
resyncInterval: ${var.ip_masq_resync_interval}
masqLinkLocal: ${var.ip_masq_link_local}
EOF
  }

  depends_on = [
    "google_container_cluster.cluster1",
  ]
}

/******************************************
  Create deployment
 *****************************************/
resource "kubernetes_deployment" "www-server" {
  metadata {
    name = "my-app"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        run = "my-app"
      }
    }

    template {
      metadata {
        labels = {
          run = "my-app"
        }
      }

      spec {
        container {
          image = "gcr.io/google-samples/hello-app:1.0"
          name  = "hello-app"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
  
 depends_on = [
    # The cluster must be up before deployments can
    # be applied.
    "google_container_cluster.cluster1",
  ]
}

/******************************************
  Create internal load-balancer service
 *****************************************/
resource "kubernetes_service" "hello-server" {
  metadata {
    name = "hello-server"

    annotations = {
      "cloud.google.com/load-balancer-type" = "Internal"
    }
  }
  
  spec {
    selector = {
      run = "my-app"
    }
    
    port {
      name     = "connectingport"
      port     = 8080
      protocol = "TCP"
    }

    type = "LoadBalancer"
    load_balancer_ip = "${var.ilb_ip}"
    load_balancer_source_ranges = ["0.0.0.0/0",]
  }
    
  depends_on = [
    # The cluster and deployment  must be up
    # before ilb service can be applied.
    "google_container_cluster.cluster1",
    "kubernetes_deployment.www-server",
  ]
}
