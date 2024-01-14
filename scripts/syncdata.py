#!/usr/bin/env python

"""
Copyright @contributors.

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

import time

# from horreum_influxdb_data_import import main as horreum_influxdb_data_import_main

# from horreum_opensearch_data_import import main as horreum_opensearch_data_import_main

from influxdb_example_time_series_data import main as influxdb_example_time_series_data_main

from opensearch_example_data import main as opensearch_example_data_main

from opensearch_import_data import main as opensearch_import_data_main

import requests


def check_opensearch_endpoint():
    """Wait for OpenSearch."""
    url = "http://admin:admin@localhost:9200/"
    max_retries = 5
    retry_delay_seconds = 10
    time.sleep(retry_delay_seconds)
    for attempt in range(max_retries):
        try:
            response = requests.get(url, verify=False)
            response.raise_for_status()
            if response.ok:
                print("Endpoint is OK")
                break
        except requests.exceptions.RequestException as e:
            print(f"Attempt {attempt + 1} failed. Error: {e}")
        time.sleep(retry_delay_seconds)
    else:
        print(f"Failed after {max_retries} attempts. Check the endpoint.")


def main():
    """Run the InfluxDB synchronization scripts."""
    influxdb_example_time_series_data_main()

    print("syncdata.py: Example time series executed")
    check_opensearch_endpoint()
    opensearch_example_data_main()
    opensearch_import_data_main()

    # horreum_influxdb_data_import_main()
    # horreum_opensearch_data_import_main()
    print("syncdata.py: File horreum to influxdb sync executed")

    print("syncdata.py: File horreum to opensearch sync executed")
    print("syncdata.py: File 'influxdb_syncdata' executed")


if __name__ == "__main__":
    main()
