#!/usr/bin/env python

"""
Copyright contributors.

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
"""
import warnings
from datetime import datetime

from dateutil import parser

from influxdb_client import Point
from influxdb_client.client.write_api import SYNCHRONOUS

from influxdb_connect import INFLUXDB_BUCKET, INFLUXDB_ORG, influx_client

import requests

from urllib3.exceptions import InsecureRequestWarning


warnings.filterwarnings("ignore", category=InsecureRequestWarning)
# The API endpoints for getting the results
DATASET_LIST_URL = "https://horreum.corp.redhat.com/api/dataset/list/"
DATASET_URL = "https://horreum.corp.redhat.com/api/dataset/"
TEST_ID = "212"


def date_to_epoch(date_string):
    """Convert a date to epoch."""
    parsed_date = parser.parse(date_string)
    datetime_obj = datetime.fromisoformat(parsed_date.isoformat())
    return int(datetime_obj.timestamp())


def epoch_length(epoch):
    """Check the epoch length."""
    try:
        # We check if its an integer (epoch)
        int(epoch)
        if len(str(epoch)) == 19:
            return "ns"
        elif len(str(epoch)) == 16:
            return "us"
        elif len(str(epoch)) == 13:
            return "ms"
        elif len(str(epoch)) == 10:
            return "s"
        else:
            print(str(epoch))
            raise Exception("Invalid epoch length")
    except ValueError:
        print('Date not an epoch')
        print(str(epoch))
        return False


def write_horreum_python_performance_data(client):
    """Get and write the performance data from Horreum."""
    # Fetch dataset list for a given test
    # Certs issues set verify to false
    write_api = client.write_api(write_options=SYNCHRONOUS)
    try:
        dataset_list_response = requests.get(f"{DATASET_LIST_URL}{TEST_ID}", verify=False)
    except requests.exceptions.RequestException as re:
        print(f"Request error: {re}")
        return False

    dataset_list = dataset_list_response.json()

    # Iterate through datasets and fetch/write result data
    for dataset in dataset_list['datasets']:
        dataset_id = dataset["id"]
        try:
            dataset_response = requests.get(f"{DATASET_URL}{dataset_id}", verify=False)
            dataset_data = dataset_response.json()
            if "data" in dataset_data and dataset_data["data"]:
                if (dataset_data["data"][0]["$schema"] == "urn:rhods-notebook-perf:1.0.0"):
                    metric = "jupyter_notebooks_performance"
                    start_epoch = dataset_data["start"]
                    measures = dataset_data["data"][0]["results"]["benchmark_measures"]["measures"]
                    image = dataset_data["data"][0]["metadata"]["settings"]["image"]

                    if not epoch_length(start_epoch):
                        start_epoch = date_to_epoch(start_epoch)

                    for measure in measures:
                        point = Point(metric) \
                            .tag("image", image) \
                            .field("execution_time", measure) \
                            .time(start_epoch, write_precision=epoch_length(start_epoch))
                        print(point)
                        print('Write performance point')
                        write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=[point])
            if "data" in dataset_data and dataset_data["data"]:
                if (dataset_data["data"][0]["$schema"] == "urn:rhods-notebooks:1.0.0"):
                    metric = "jupyter_notebooks_scale"

                    if "test_flavor" in dataset_data["data"][0]["metadata"]["settings"] and dataset_data["data"][0]["metadata"]["settings"]["test_flavor"] and \
                       "user_count" in dataset_data["data"][0]["metadata"]["settings"] and dataset_data["data"][0]["metadata"]["settings"]["user_count"] and \
                       "start" in dataset_data["data"][0]["metadata"] and dataset_data["data"][0]["metadata"]["start"]:

                        start_epoch = dataset_data["data"][0]["metadata"]["start"]
                        user_count = dataset_data["data"][0]["metadata"]["settings"]["user_count"]
                        test_flavor = dataset_data["data"][0]["metadata"]["settings"]["test_flavor"]

                        if not epoch_length(start_epoch):
                            start_epoch = date_to_epoch(start_epoch)

                        point = Point(metric) \
                            .tag("test_flavor", test_flavor) \
                            .field("user_count", user_count) \
                            .time(start_epoch, write_precision=epoch_length(start_epoch))
                        print(point)
                        print('Write scale point')
                        write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=[point])

        except requests.exceptions.RequestException as re:
            print(f"Request error: {re}")


def main():
    """Import data into Horreum."""
    client = influx_client()
    write_horreum_python_performance_data(client)
    client.close()
    print('horreum_data_import.py: Finished horreum_data_import')


if __name__ == "__main__":
    main()
