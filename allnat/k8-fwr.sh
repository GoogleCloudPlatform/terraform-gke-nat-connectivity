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


# This script identifies and deletes GKE created firewall rules.

echo 'Initializing environment variables.'
source TF_ENV_VARS

echo 'Identifying kubernetes firewill rules in the isolated VPC.'
FWRs="$(gcloud compute firewall-rules list \
         --project="$TF_VAR_isolated_vpc_pid" | grep INGRESS | \
         awk '!/def/ {print "$1"}')"

if [[ "${#FWRs[@]}" -gt 0 ]]; then
  echo 'Deleteing firewall rules in the isolated VPC.'
  gcloud compute firewall-rules delete "$FWRs" \
    --project="$TF_VAR_isolated_vpc_pid" 
    --quiet
else
    echo 'There are no FWRs in the isolated VPC to delete.'
fi
