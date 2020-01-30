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
#
#<!--* freshness: { owner: 'ttaggart@google.com' reviewed: '2020-feb-01' } *-->


#Enable packet forwarding
sudo sysctl -w net.ipv4.ip_forward=1

#Check and create routed-domain routing table
TABLE_EXISTS="$(awk '/100 routed-domain/ {print}' \
    /etc/iproute2/rt_tables | wc -l)"
if [[ "$TABLE_EXISTS" -eq 0 ]]; then
   echo "100 routed-domain" >> /etc/iproute2/rt_tables;
fi

#Add policy routing rule
ip rule add to 10.0.0.0/8 table routed-domain
ip rule add to 172.16.0.0/12 table routed-domain
ip rule add to 192.168.0.0/16 table routed-domain

#Add routes to routed-domain
#This section is put into a file and ran separately
#to avoid race conditions where eth1 has not started
#before these commands are called.
cat <<EOF > ./addRoutes.sh
#! /bin/bash
sleep 10
ip route add to 10.32.31.0/24 \
    via 10.32.0.1 dev eth1 table routed-domain
ip route add to 10.0.0.0/8 \
    via 10.97.0.1 dev eth0 table routed-domain
ip route add to 172.16.0.0/12 \
    via 10.97.0.1 dev eth0 table routed-domain
ip route add to 192.168.0.0/16 \
    via 10.97.0.1 dev eth0 table routed-domain
EOF
chmod 755 ./addRoutes.sh
./addRoutes.sh & disown

#Configure NAT
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE

#Add tooling
sudo apt-get -y install iptables-persistent
sudo apt-get -y install conntrack
sudo apt-get -y install tcpdump

