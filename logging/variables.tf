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


variable "user_account" {
   type = "string"
   description = "GCP user account used to complete solution."
}

variable "billing_account" {
   type = "string"
   description = "GCP billing account number." 
}

variable "org_id" {
   type = "string"
   description = "GCP organization number."
}

variable "shared_vpc_pid" {
   type = "string"
   description = "GCP project ID of the host project."
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

variable "service_cidr" {
   type = "string"
   description = "CIDR block used for Kubernetes services." 
}

variable "shared_cidr" {
   type = "string"
   description = "CIDR block assigned to the shared subnet in the host project." 
}

variable "shared_net_name" {
   type = "string"
   description = "Name of the VPC network in the host project."
}

variable "isolated_net_name" {
   type = "string"
   description = "Name of the VPC network in the isolated project."
}

variable "region" {
   type = "string"
   description = "GCP region where resources are created."
}

variable "zone" {
   type = "string"
   description = "GCP zone in the var.region where resources are created."
}

variable "test1_cidr" {
   type = "string"
   description = <<-EOT
     CIDR block for the test1 subnetwork. This CIDR block overlaps with the
     CIDR block used for kubernetes pods in the isolated VPC.
     EOT
}

variable "test2_cidr" {
   type = "string"
   description = <<-EOT
     CIDR block for the test2 subnetwork. In some data flows this
     CIDR block is also considered a routed-domain reused address 
     range in the isolated VPC.
     EOT
}

variable "test3_cidr" {
   type = "string"
   description = <<-EOT
     CIDR block for the test3 subnetwork. In some data flows this 
     CIDR block is also considered a routed-domain reused address 
     range in the isolated VPC.
     EOT
}

variable "ilb_cidr" {
   type = "string"
   description = "CIDR block for the kubernetes defined internal load balancer."
}

variable "masquerade"{
  type = "string"
  description = <<-EOT
    This variable defines the NAT configuration on the isolated VPC gateway. 
    The string should be set to either "true" or "false".
    EOT
}

variable "isolated_vpc_gw_host_nic_ip"{
  type = "string"
  description = <<-EOT
    IP address on the NIC of the isolated-vpc gateway in the routed-domain.
    EOT
}

variable "isolated_vpc_gw_service_nic_ip"{
  type = "string"
  description = <<-EOT
    IP address on the NIC of the isolated-vpc gateway in the isolated VPC.
    EOT
}
/*
variable "db_password"{
  type = "string"
  description = <<-EOT
    Postgres database password.
    EOT
}
*/
variable "db_username"{
  type = "string"
  description = <<-EOT
    Postgres database username.
    EOT
}

variable "private_access_cidr"{
  type = "string"
  description = <<-EOT
    IP CIDR block for GCP private access.
    EOT
}

variable "non_masquerade_cidrs" {
  type        = "list"
  description = "List of strings in CIDR notation that specify the IP address ranges that do not use IP masquerading."
  default     = ["10.32.0.0/24", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "ip_masq_resync_interval" {
  description = "The interval at which the agent attempts to sync its ConfigMap file from the disk."
  default     = "60s"
}

variable "ip_masq_link_local" {
  description = "Whether to masquerade traffic to the link-local prefix (169.254.0.0/16)."
  default     = "false"
}

variable "ilb_ip"{
  type = "string"
  description = <<-EOT
    IP address of the internal load balancer.
    EOT
}
