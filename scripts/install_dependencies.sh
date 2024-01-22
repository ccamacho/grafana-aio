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
apt-get update -y
apt-get upgrade -y
apt-get install -y git jq wget nano python3 python3-pip build-essential tar curl zip unzip pkg-config libpcap-dev
# Install supervisor, and cron
apt-get install -y supervisor cron
# Install InfluxDB v2 available
echo 'deb [allow-insecure=yes trusted=yes] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
apt-get update -y
apt-get install -y influxdb2

python3 -m pip install --upgrade pip
python3 -m pip install --upgrade wheel
python3 -m pip install --upgrade shyaml netaddr ipython dnspython
python3 -m pip install -r requirements.txt

### We install all the dependencies in /opt
# Install grafanalib from sources because pypi is +1y old
cd /opt
git clone https://github.com/weaveworks/grafanalib grafanalib_sources
cd grafanalib_sources
# We install grafanalib as root to have it available for all users in the
# container
python3 -m pip install -e .

### Install additional software
# Install grabana
# This is a binary so we need to create a folder to store it first
cd /opt
mkdir grabana
curl -SL https://github.com/K-Phoen/grabana/releases/download/v0.22.1/grabana_0.22.1_linux_amd64.tar.gz | tar -zxC grabana
mv grabana/grabana /usr/local/bin/
chmod +x /usr/local/bin/grabana

# Install latest jsonnet
cd /opt
git clone https://github.com/google/jsonnet.git jsonnet-sources
cd jsonnet-sources
make
mv jsonnet /usr/local/bin/jsonnet
chmod +x /usr/local/bin/jsonnet
# Install jsonnet bundler
cd /opt
curl -SL https://github.com/jsonnet-bundler/jsonnet-bundler/releases/download/v0.5.1/jb-linux-amd64 -o /usr/local/bin/jb
chmod +x /usr/local/bin/jb
jb --version
# Here we install both versions of grafonnet
# (the old grafonnet-lib and the new grafonnet)
cd /opt/jsonnet_deps
jb install

### Begin install additional Grafana plugins
# All used plugins must be installed first
# than using them in the provision scripts
grafana cli plugins install nline-plotlyjs-panel
grafana cli plugins install grafana-opensearch-datasource
### End installing additional plugins

# Install Prometheus
PROMETHEUS_VERSION="2.48.1"
cd /opt
mkdir /etc/prometheus
mkdir /var/lib/prometheus
curl -SL https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.linux-amd64.tar.gz | tar -zx
cd prometheus-$PROMETHEUS_VERSION.linux-amd64
mv prometheus /usr/local/bin
mv promtool /usr/local/bin
mv consoles /etc/prometheus
mv console_libraries /etc/prometheus
mv prometheus.yml /etc/prometheus

# Install OpenSearch
OPENSEARCH_VERSION="2.11.1"
cd /opt
curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch/$OPENSEARCH_VERSION/opensearch-$OPENSEARCH_VERSION-linux-x64.tar.gz | tar -zx
mv opensearch-$OPENSEARCH_VERSION opensearch
./opensearch/bin/opensearch-plugin install https://github.com/Aiven-Open/prometheus-exporter-plugin-for-opensearch/releases/download/$OPENSEARCH_VERSION.0/prometheus-exporter-$OPENSEARCH_VERSION.0.zip && \
rm -rf ./opensearch/plugins/opensearch-security
curl -SL https://artifacts.opensearch.org/releases/bundle/opensearch-dashboards/$OPENSEARCH_VERSION/opensearch-dashboards-$OPENSEARCH_VERSION-linux-x64.tar.gz | tar -zx
mv opensearch-dashboards-$OPENSEARCH_VERSION opensearch-dashboards
./opensearch-dashboards/bin/opensearch-dashboards-plugin remove securityDashboards --allow-root
