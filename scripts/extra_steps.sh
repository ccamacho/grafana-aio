#!/bin/bash
set -o pipefail
set -ex

#############################################################################
#                                                                           #
# Copyright          contributors.                                          #
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
# This script is executed when building the container image
###

# Install grafanalib from sources because pypi is +1y old
git clone https://github.com/weaveworks/grafanalib grafanalib_sources
cd grafanalib_sources
pip install -e .

# Install grafonnet
# NO need to install we pull from the git repo
# git clone https://github.com/grafana/grafonnet-lib.git
