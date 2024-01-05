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

import random
from datetime import datetime, timedelta

from influxdb_client import Point
from influxdb_client.client.write_api import SYNCHRONOUS

from influxdb_connect import INFLUXDB_BUCKET, INFLUXDB_ORG, influx_client


def write_random_data(client):
    """Write random data in the database."""
    nb_day = 15  # number of day to generate time series
    timeinterval_min = 5
    total_minutes = 1440 * nb_day
    total_records = int(total_minutes / timeinterval_min)
    now = datetime.today()
    metric = "cpu_idle"
    series = []

    for i in range(0, total_records):
        past_date = now - timedelta(minutes=i * timeinterval_min)
        value = random.randint(0, 200)
        hostname = "image-%d" % random.randint(1, 5)
        point = Point(metric).tag("hostName", hostname).field("value", value).time(past_date.strftime('%Y-%m-%dT%H:%M:%SZ'))
        series.append(point)

    write_api = client.write_api(write_options=SYNCHRONOUS)
    write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=series)


def write_series_no_time(client):
    """Write two points in the database."""
    write_api = client.write_api(write_options=SYNCHRONOUS)
    data_points = [
        Point("temperature").tag("server_name", "us.east-1").field("value", 42).field("desv", 4),
        Point("temperature").tag("server_name", "us.east-1").field("value", 42).field("desv", 4)
    ]
    write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=data_points)


def main():
    """Generate random data for InfluxDB."""
    client = influx_client()
    write_random_data(client)
    write_series_no_time(client)
    client.close()
    print('example_time_series_data.py: Finished example_time_series_data')


if __name__ == "__main__":
    main()
