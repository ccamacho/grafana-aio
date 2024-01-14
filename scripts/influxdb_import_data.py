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

import csv
from datetime import datetime

from influxdb_client import Point
from influxdb_client.client.write_api import SYNCHRONOUS

from influxdb_connect import INFLUXDB_BUCKET, INFLUXDB_ORG, influx_client


def import_latency(client):
    """Write latency data."""
    write_api = client.write_api(write_options=SYNCHRONOUS)
    data_path = './datasets/latency.csv'

    with open(data_path, 'r') as file:
        measurement = 'latency'
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            timestamp_str = row[0]
            timestamp = datetime.strptime(timestamp_str, "%Y-%m-%d %H:%M:%S")
            day_of_year = timestamp.timetuple().tm_yday
            degrees = day_of_year * 360.0 / 365.0
            point = Point(measurement) \
                .time(timestamp) \
                .field("degrees", int(degrees)) \
                .field("llama-65b-2023:01", int(row[1])) \
                .field("llana-30b-2023:6", int(row[2])) \
                .field("vicuna-38b-2023:6", int(row[3])) \
                .field("llama-500b-2023:12", int(row[4])) \
                .field("vicuna-3b-2023:8", int(row[5])) \
                .field("vicuna-80b-2024:1", int(row[6]))
            write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)

    with open(data_path, 'r') as file:
        measurement = 'latency_labelled'
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            timestamp_str = row[0]
            timestamp = datetime.strptime(timestamp_str, "%Y-%m-%d %H:%M:%S")
            points = []
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[1]))
                          .tag("llama-65b", "2023:01"))
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[2]))
                          .tag("llama-65b", "2023:06"))
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[3]))
                          .tag("vicuna-38b", "2023:6"))
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[4]))
                          .tag("llama-65b", "2023:12"))
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[5]))
                          .tag("vicuna-38b", "2023:08"))
            points.append(Point(measurement)
                          .time(timestamp)
                          .field("latency_ms", int(row[6]))
                          .tag("vicuna-38b", "2024:01"))
            write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=points)


def import_loss(client):
    """Write latency data."""
    write_api = client.write_api(write_options=SYNCHRONOUS)
    data_path = './datasets/loss.csv'
    measurement = 'loss'
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            point = Point(measurement) \
                .field("Image", str(row[0])) \
                .field("Label1", str(row[1])) \
                .field("Label2", str(row[2])) \
                .field("Label3", str(row[3])) \
                .field("Llama 8B", float(row[4])) \
                .field("Llama 36B", float(row[5])) \
                .field("Vicuna 8B", float(row[6]))
            write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)


def import_throughput(client):
    """Write throughput data."""
    write_api = client.write_api(write_options=SYNCHRONOUS)
    data_path = './datasets/throughput.csv'
    measurement = 'throughput'
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            point = Point(measurement) \
                .field("Image", str(row[0])) \
                .field("Llama 8B", float(row[1])) \
                .field("Llama 36B", float(row[2])) \
                .field("Vicuna 8B", float(row[3])) \
                .field("Vicuna 36B", float(row[4]))
            write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)


def import_accuracy(client):
    """Write accuracy data."""
    write_api = client.write_api(write_options=SYNCHRONOUS)
    data_path = './datasets/accuracy.csv'
    measurement = 'accuracy'
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            point = Point(measurement) \
                .field("first", row[0]) \
                .field("second", row[1]) \
                .field("third", row[2]) \
                .field("four", row[3]) \
                .field("five", row[4]) \
                .field("six", row[5])
            write_api.write(bucket=INFLUXDB_BUCKET, org=INFLUXDB_ORG, record=point)


def main():
    """Import mock data in InfluxDB."""
    client = influx_client()
    import_latency(client)
    import_loss(client)
    import_accuracy(client)
    import_throughput(client)
    client.close()
    print('example_time_series_data.py: Finished example_time_series_data')


if __name__ == "__main__":
    main()
