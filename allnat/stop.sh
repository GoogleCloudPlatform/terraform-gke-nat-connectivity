#!/bin/bash
#
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


# This script stops the virtual machines and the Kubernetes cluster.

echo 'Initializing environment variables.'
source TF_ENV_VARS

echo 'Identifying VMs in the isolated VPC.'
VMs="$(gcloud compute instances list \
        --project="$TF_VAR_isolated_vpc_pid" \
        --filter=zone:"${TF_VAR_zone}" | awk '/host|vm|vpc/ {print "$1"}')"

if [[ "${#VMs[@]}" -gt 0 ]]; then
  echo 'Stopping VMs in the isolated VPC.'
  gcloud compute instances stop "$VMs" \
    --project="$TF_VAR_isolated_vpc_pid" \
    --zone="${TF_VAR_zone}"
else
    echo 'There are no VMs in the isolated VPC to stop.'
fi

echo 'Identifying VMs in the shared VPC.'
VMs="$(gcloud compute instances list \
        --project="$TF_VAR_shared_vpc_pid" \
        --filter=zone:"${TF_VAR_zone}" \
        | awk '/host|vm|vpc/ {print $1}')"

if [[ "${#VMs[@]}" -gt 0 ]]; then
  echo 'Stopping VMs in the shared VPC.'
  gcloud compute instances stop "$VMs" \
    --project="$TF_VAR_shared_vpc_pid" \
    --zone="${TF_VAR_zone}"
else
    echo 'There are no VMs in the isolated VPC to stop.'
fi

echo 'Resizing cluster to 0 VMs.'
gcloud container clusters resize "$TF_VAR_cluster_name" \
  --zone="${TF_VAR_zone}" \
  --size=0 \
  --quiet

