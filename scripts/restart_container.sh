#!/bin/bash
set -o pipefail

#############################################################################
#                                                                           #
# Copyright @contributors.                                                  #
#                                                                           #
# Licensed under the Apache License, Version 2.0 (the "License"); you may   #
# not use this file except in compliance with the License. You may obtain   #
# a copy of the License at:                                                 #
#                                                                           #
# http://www.apache.org/licenses/LICENSE-2.0                                #
#                                                                           #
# Unless required by applicable law or agreed to in writing, software       #
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT #
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the  #
# License for the specific language governing permissions and limitations   #
# under the License.                                                        #
#                                                                           #
#############################################################################

sudo docker stop grafana-aio 2>/dev/null
sudo docker remove grafana-aio 2>/dev/null
echo 'Checking for a new version...'
sudo docker pull ghcr.io/ccamacho/grafana-aio:latest
sudo docker run -d \
    -p 3000:3000 \
    -p 9090:9090 \
    -p 9200:9200 \
    -p 5601:5601 \
    -p 8086:8086 \
    --pull always \
    --name grafana-aio \
    ghcr.io/ccamacho/grafana-aio:latest
echo 'Container started successfully.'

sudo iptables -I DOCKER-USER -j ACCEPT
sudo iptables -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I INPUT -m conntrack --ctstate NEW -p tcp --syn -j ACCEPT
sudo iptables -P FORWARD ACCEPT

: <<'END_COMMENT'
### Packages
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install aptitude -y
sudo aptitude install docker.io git nano cron -y
cd
git clone https://github.com/ccamacho/grafana-aio

### Cron
0 */5 * * * sudo /home/ubuntu/grafana-aio/scripts/restart_container.sh

### Swap
sudo fallocate -l 10G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
END_COMMENT
