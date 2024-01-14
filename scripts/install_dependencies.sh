#!/bin/bash
set -o pipefail
set -ex

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

###
# This script is executed when building the container image, use only
# for installing additional dependencies
###

# Install packages and dependencies
apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y sudo git jq wget nano python3 python3-pip build-essential tar curl zip unzip pkg-config
# Install supervisor, and cron
apt-get install -y supervisor && \
    apt-get install -y cron
# Install InfluxDB v2 available
echo 'deb [allow-insecure=yes trusted=yes] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list  && \
    apt-get update -y && apt-get install -y influxdb2

python3 -m pip install --upgrade pip
python3 -m pip install --upgrade wheel
python3 -m pip install --upgrade shyaml netaddr ipython dnspython
python3 -m pip install -r requirements.txt

# Install grafanalib from sources because pypi is +1y old
git clone https://github.com/weaveworks/grafanalib grafanalib_sources
cd grafanalib_sources
# We install grafanalib as root to have it available for all users in the
# container
python3 -m pip install -e .

# Install grafonnet
# NO need to install we pull from the git repo
# git clone https://github.com/grafana/grafonnet-lib.git
