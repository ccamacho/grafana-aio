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
import os
import pathlib
from datetime import datetime

from opensearchpy import OpenSearch

current_working_directory = pathlib.Path.home()


# Better to use a different index per document type?
# If they are totally different structures, yes.
# And another for the LTS payload?
def opensearch_write_accuracy(client):
    """Write accuracy data in OpenSearch."""
    index_name = 'rhoai_perfdata_accuracy'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }
    # Check if the index already exists
    if not client.indices.exists(index=index_name):
        client.indices.create(index=index_name, body=index_body)
        print(f"Index '{index_name}' created.")
    else:
        print(f"Index '{index_name}' already exists.")

    data_path = os.path.join(current_working_directory, 'scripts/datasets/accuracy.csv')
    print(data_path)
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            now = datetime.today()
            document = {
                "@timestamp": now.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                'Llama 8B': float(row[0]) if len(row) > 0 and row[0] != "" else None,
                'Llama 36B': float(row[1]) if len(row) > 1 and row[1] != "" else None,
                'Llama 100B': float(row[2]) if len(row) > 2 and row[2] != "" else None,
                'Vicuna 8B': float(row[3]) if len(row) > 3 and row[3] != "" else None,
                'Vicuna 36B': float(row[4]) if len(row) > 4 and row[4] != "" else None,
                'Vicuna 100B': float(row[5]) if len(row) > 5 and row[5] != "" else None,
            }
            client.index(
                index=index_name,
                body=document,
                refresh=True
            )


def opensearch_write_latency(client):
    """Write latency data in OpenSearch."""
    index_name = 'rhoai_perfdata_latency'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }
    # Check if the index already exists
    if not client.indices.exists(index=index_name):
        client.indices.create(index=index_name, body=index_body)
        print(f"Index '{index_name}' created.")
    else:
        print(f"Index '{index_name}' already exists.")
    data_path = os.path.join(current_working_directory, 'scripts/datasets/latency.csv')
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            timestamp_str = row[0]
            timestamp = datetime.strptime(timestamp_str, "%m-%d-%Y %H:%M")
            document = {
                "@timestamp": timestamp.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                'Image': str(row[1]) if len(row) > 1 and row[1] != "" else None,
                'Llama 8B': float(row[2]) if len(row) > 2 and row[2] != "" else None,
                'Llama 36B': float(row[3]) if len(row) > 3 and row[3] != "" else None,
                'Llama 100B': float(row[4]) if len(row) > 4 and row[4] != "" else None,
                'Vicuna 8B': float(row[5]) if len(row) > 5 and row[5] != "" else None,
                'Vicuna 36B': float(row[6]) if len(row) > 6 and row[6] != "" else None,
                'Vicuna 100B': float(row[7]) if len(row) > 7 and row[7] != "" else None,
            }

            client.index(
                index=index_name,
                body=document,
                refresh=True
            )


def opensearch_write_loss(client):
    """Write loss data in OpenSearch."""
    index_name = 'rhoai_perfdata_loss'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }
    # Check if the index already exists
    if not client.indices.exists(index=index_name):
        client.indices.create(index=index_name, body=index_body)
        print(f"Index '{index_name}' created.")
    else:
        print(f"Index '{index_name}' already exists.")
    data_path = os.path.join(current_working_directory, 'scripts/datasets/loss.csv')
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            now = datetime.today()
            document = {
                "@timestamp": now.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                'Image': str(row[0]) if len(row) > 0 and row[0] != "" else None,
                'Label1': str(row[1]) if len(row) > 1 and row[1] != "" else None,
                'Label2': str(row[2]) if len(row) > 2 and row[2] != "" else None,
                'Label3': str(row[3]) if len(row) > 3 and row[3] != "" else None,
                'Llama 8B': float(row[4]) if len(row) > 4 and row[4] != "" else None,
                'Llama 36B': float(row[5]) if len(row) > 5 and row[5] != "" else None,
                'Vicuna 8B': float(row[6]) if len(row) > 6 and row[6] != "" else None,
            }
            client.index(
                index=index_name,
                body=document,
                refresh=True
            )


def opensearch_write_throughput(client):
    """Write throughput data in OpenSearch."""
    index_name = 'rhoai_perfdata_throughput'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }
    # Check if the index already exists
    if not client.indices.exists(index=index_name):
        client.indices.create(index=index_name, body=index_body)
        print(f"Index '{index_name}' created.")
    else:
        print(f"Index '{index_name}' already exists.")
    data_path = os.path.join(current_working_directory, 'scripts/datasets/throughput.csv')
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            now = datetime.today()
            document = {
                "@timestamp": now.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                'Image': str(row[0]) if len(row) > 0 and row[0] != "" else None,
                'Llama 8B': float(row[1]) if len(row) > 1 and row[1] != "" else None,
                'Llama 36B': float(row[2]) if len(row) > 2 and row[2] != "" else None,
                'Vicuna 8B': float(row[3]) if len(row) > 3 and row[3] != "" else None,
                'Vicuna 36B': float(row[4]) if len(row) > 4 and row[4] != "" else None,
            }
            client.index(
                index=index_name,
                body=document,
                refresh=True
            )


def main():
    """Generate random data for OpenSearch."""
    script_executed = '/tmp/opensearch_import_data_executed'
    if os.path.exists(script_executed):
        print("Script has already been executed. Exiting.")
        exit()

    host = 'localhost'
    port = 9200
    auth = ('admin', 'admin')  # For testing only. Don't store credentials in code.

    # Create the client with SSL/TLS enabled, but hostname verification disabled.
    client = OpenSearch(
        hosts=[{'host': host, 'port': port}],
        timeout=60,
        http_compress=True,
        http_auth=auth,
        use_ssl=False,
        verify_certs=False,
        ssl_assert_hostname=False,
        ssl_show_warn=False,
    )

    opensearch_write_accuracy(client)
    opensearch_write_latency(client)
    opensearch_write_loss(client)
    opensearch_write_throughput(client)
    client.close()
    print('example_time_series_data.py: Finished example_time_series_data')

    with open(script_executed, 'w') as flag_file:
        flag_file.write("Executed")


if __name__ == "__main__":
    main()
