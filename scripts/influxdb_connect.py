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

from influxdb_client import InfluxDBClient

# Define InfluxDB connection parameters
INFLUXDB_HOST = 'localhost'
INFLUXDB_PORT = 8086
INFLUXDB_BUCKET = 'psap'
INFLUXDB_BUCKET_RETENTION = '500w'
INFLUXDB_USER = 'psap'
INFLUXDB_PASSWORD = 'this_is_a_very_long_password'
INFLUXDB_TOKEN = 'Z0naPts1oKBrUe7N4uP7M-Hb8Qt7r9lQZJwYxEM8k8gb_VqOjODlHLa8pyjwrvkIaB4uMOkvmWlmWXS2CmL7mg=='
INFLUXDB_ORG = 'psap'


def influx_client():
    """Return an InfluxDB client."""
    client = InfluxDBClient(url='http://' + INFLUXDB_HOST + ':' + str(INFLUXDB_PORT),
                            username=INFLUXDB_USER,
                            password=INFLUXDB_PASSWORD,
                            org=INFLUXDB_ORG)
    return client


if __name__ == "__main__":
    influx_client
    #
    # Do not add any other print than the
    # variables that will be evaluated
    # in the initialize_data_sync.sh script
    #
    print(f"INFLUXDB_HOST={INFLUXDB_HOST}")
    print(f"INFLUXDB_PORT={INFLUXDB_PORT}")
    print(f"INFLUXDB_BUCKET={INFLUXDB_BUCKET}")
    print(f"INFLUXDB_BUCKET_RETENTION={INFLUXDB_BUCKET_RETENTION}")
    print(f"INFLUXDB_USER={INFLUXDB_USER}")
    print(f"INFLUXDB_PASSWORD={INFLUXDB_PASSWORD}")
    print(f"INFLUXDB_TOKEN={INFLUXDB_TOKEN}")
    print(f"INFLUXDB_ORG={INFLUXDB_ORG}")
