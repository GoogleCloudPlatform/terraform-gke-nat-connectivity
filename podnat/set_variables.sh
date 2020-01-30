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


export TF_VAR_gcp_user="$(gcloud auth list \
  --filter=status:ACTIVE \
  --format="value(account)")"

export TF_VAR_billing_account="$(gcloud beta billing accounts list \
  | grep "${TF_VAR_gcp_user}" \
  | awk '{print $1}')"

export TF_VAR_isolated_vpc_pid="$(echo ivpc-pid-$(od -An -N4 -i /dev/random) \
  | sed 's/ //')"

export TF_VAR_cluster_cidr=192.168.1.0/24
export TF_VAR_pod_cidr=172.16.0.0/16
export TF_VAR_node_cidr=10.32.1.0/24
export TF_VAR_ilb_ip=10.32.1.49
export TF_VAR_on_prem_cidr=10.32.2.0/24
export TF_VAR_region=us-west1
export TF_VAR_zone=us-west1-b
