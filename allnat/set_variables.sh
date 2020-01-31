#!/bin/bash

# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2020-feb-01' } *-->


# This script sets the env variables.


export TF_VAR_user_account="$(gcloud auth list \
  --filter=status:ACTIVE \
  --format="value(account)")"

export TF_VAR_billing_account="$(gcloud beta billing accounts list \
  | grep "${TF_VAR_user_account}" \
  | awk '{print $1}')"

export TF_VAR_shared_vpc_pid="$(echo svpc-pid-$(od -An -N4 -i /dev/random) \
  | sed 's/ //')"

export TF_VAR_isolated_vpc_pid="$(echo ivpc-pid-$(od -An -N4 -i /dev/random) \
  | sed 's/ //')"

export TF_VAR_isolated_net_name=isolated-vpc-net
export TF_VAR_isolated_pname=isolated-vpc-pname
export TF_VAR_shared_net_name=routed-domain-vpc-net
export TF_VAR_shared_pname=routed-domain-pname
export TF_VAR_isolated_vpc_gw_host_nic_ip=10.97.0.2
export TF_VAR_isolated_vpc_gw_service_nic_ip=10.32.0.2
export TF_VAR_isolated_vpc_gw_service_dgw_ip=10.32.0.1
export TF_VAR_region=us-west1
export TF_VAR_zone=us-west1-b
export TF_VAR_cluster_name=kam_cluster
export TF_VAR_node_cidr=10.32.0.0/19
export TF_VAR_pod_cidr=10.0.0.0/11
export TF_VAR_service_cidr=10.224.0.0/20
export TF_VAR_shared_cidr=10.97.0.0/24
export TF_VAR_test1_cidr=10.0.0.0/11
export TF_VAR_test2_cidr=10.160.0.0/11
export TF_VAR_test3_cidr=10.64.0.0/19
export TF_VAR_masquerade=true
export TF_VAR_ilb_cidr=10.32.31.0/24
export TF_VAR_ilb_ip=10.32.31.1
