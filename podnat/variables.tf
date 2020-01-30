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


variable "org_id" {
   type = "string"
   description = "GCP organization number."
}

variable "gcp_user" {
   type = "string"
   description = "GCP user account used to complete solution."
}

variable "billing_account" {
   type = "string"
   description = "GCP billing account number." 
}

variable "isolated_vpc_pid" {
   type = "string"
   description = "GCP project ID of the service project." 
}

variable "node_cidr" {
   type = "string"
   description = "CIDR block used for Kubernetes nodes." 
}

variable "pod_cidr" {
   type = "string"
   description = "CIDR block used for Kubernetes pods." 
}

variable "cluster_cidr" {
   type = "string"
   description = "CIDR block used for Kubernetes services." 
}

variable "ilb_ip" {
   type = "string"
   description = "IPv4 address for the kubernetes defined internal load balancer."
}

variable "region" {
   type = "string"
   description = "GCP region where resources are created."
}

variable "zone" {
   type = "string"
   description = "GCP zone in the var.region where resources are created."
}

variable "on_prem_cidr" {
   type = "string"
   description = "CIDR block for the simulated on-prem subnetwork."
}

variable "non_masquerade_cidrs" {
  type        = "list"
  description = "List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading."
  default     = ["10.32.1.0/24", "172.16.0.0/16", "192.168.1.0/24"]
}

variable "ip_masq_resync_interval" {
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  default     = "60s"
}

variable "ip_masq_link_local" {
  description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
  default     = "false"
}

