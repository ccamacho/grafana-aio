#!/bin/bash
set -o pipefail
set -ex

#############################################################################
#                                                                           #
# Copyright @contributors.                                                   #
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

scripts_path="/home/grafana/scripts/"

init_influxdb(){
    echo "initialize_data_sync.sh: Get connection details"
    python_output=$(python3 "${scripts_path}influxdb_connect.py")
    eval "$python_output"

    echo "INFLUXDB_HOST: $INFLUXDB_HOST"
    echo "INFLUXDB_PORT: $INFLUXDB_PORT"
    echo "INFLUXDB_BUCKET: $INFLUXDB_BUCKET"
    echo "INFLUXDB_BUCKET_RETENTION: $INFLUXDB_BUCKET_RETENTION"
    echo "INFLUXDB_USER: $INFLUXDB_USER"
    echo "INFLUXDB_PASSWORD: $INFLUXDB_PASSWORD"
    echo "INFLUXDB_TOKEN: $INFLUXDB_TOKEN"
    echo "INFLUXDB_ORG: $INFLUXDB_ORG"

    echo "initialize_data_sync.sh: Run setup"
    influx setup \
        --bucket=$INFLUXDB_BUCKET \
        --org=$INFLUXDB_ORG \
        --username=$INFLUXDB_USER \
        --password=$INFLUXDB_PASSWORD \
        --retention=$INFLUXDB_BUCKET_RETENTION \
        --host="http://$INFLUXDB_HOST:$INFLUXDB_PORT" \
        --token=$INFLUXDB_TOKEN \
        --force

    sleep 2

    INFLUXDB_BUCKET_ID=$(influx bucket list --json | jq -r '.[] | select(.name == "psap") | .id')

    echo "initialize_data_sync.sh: Create backwards compatibility DBRP"
    influx v1 dbrp create \
        --db=$INFLUXDB_BUCKET \
        --rp="autogen" \
        --bucket-id=$INFLUXDB_BUCKET_ID \
        --default

    sleep 2

    echo "initialize_data_sync.sh: Create backwards compatibility auth"
    influx v1 auth create \
        --read-bucket=$INFLUXDB_BUCKET_ID \
        --write-bucket=$INFLUXDB_BUCKET_ID \
        --username=$INFLUXDB_USER \
        --password=$INFLUXDB_PASSWORD

    sleep 2

    echo "initialize_data_sync.sh: Get some status details"
    influx bucket list
    influx v1 dbrp list
    influx v1 auth list
}

init_syncdata(){
    sleep 5
    echo "initialize_data_sync.sh: Sync data from syncdata.py"
    python_output=$(python3 "${scripts_path}syncdata.py")
    echo "$python_output"
}

create_grafana_readonly_user(){
    sleep 5

    while :
    do
        response=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:3000/login)
        if [ "$response" == "200" ]; then
            curl -XPOST -H "Content-Type: application/json" -d '{
            "name":"readonly",
            "email":"readonly@example.com",
            "login":"readonly",
            "password":"readonly"
            }' http://administrator:1234@127.0.0.1:3000/api/admin/users
            break
        else
            sleep 5
        fi
    done

    echo "initialize_data_sync.sh: Created readonly user"
}

run_once(){
    temp_file='/tmp/initialize_data_sync.txt'
    echo "initialize_data_sync.sh: Temp file $temp_file"

    if [ -e "$temp_file" ]; then
        echo "initialize_data_sync.sh: Initdb already executed. Exiting."
        return
    fi

    create_grafana_readonly_user
    init_influxdb
    init_syncdata

    echo "initialize_data_sync.sh: status in $temp_file"
    echo "initialize_data_sync.sh: was executed" > $temp_file
}

sleep 5

while true; do
    run_once
    sleep 36000
done
