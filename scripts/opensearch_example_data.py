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
import time
from datetime import datetime, timedelta

from opensearchpy import OpenSearch
from opensearchpy.exceptions import RequestError


def wait_for_opensearch(client, timeout=60, check_interval=5):
    """
    Wait for the OpenSearch cluster to be in a "green" state.

    :param client: OpenSearch client instance
    :param timeout: Maximum time (in seconds) to wait for the cluster to be in a "green" state
    :param check_interval: Interval (in seconds) between status checks
    """
    start_time = time.time()

    while time.time() - start_time < timeout:
        try:
            # Check the cluster health
            response = client.cluster.health(index="_all", wait_for_status="green", request_timeout=check_interval)
            if response['status'] == 'green':
                print("Cluster is in a 'green' state.")
                return
        except Exception as e:
            # Handle exceptions if needed
            print(f"Error checking cluster status: {e}")

        # Sleep before the next status check
        time.sleep(check_interval)

    # Raise an exception if the timeout is reached
    raise TimeoutError(f"Timed out waiting for the cluster to be in a 'green' state after {timeout} seconds.")


def generate_cpu_idle_data():
    """Generate random CPU idle percentage data."""
    data = []

    for i in range(1, 101):  # Generate 100 data points
        timestamp = datetime.now() - timedelta(minutes=i)
        cpu_idle_percentage = round(random.uniform(0, 100), 2)
        document = {
            'cpu_idle_percentage': cpu_idle_percentage,
            '@timestamp': timestamp.strftime('%Y-%m-%dT%H:%M:%S.%fZ')
        }
        data.append(document)

    return data


def write_data_in_opensearch(client):
    """Write data in OpenSearch."""
    # Create an index with non-default settings.
    index_name = 'python_test'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }
    try:
        # Your OpenSearch client and index creation code here
        response = client.indices.create(index_name, body=index_body)
        print(f"Index '{index_name}' created successfully.")
    except RequestError as e:
        if "resource_already_exists_exception" in str(e):
            print(f"Index '{index_name}' already exists.")
        else:
            # Handle other RequestError exceptions or re-raise the exception
            print(f"An error occurred: {e}")
            raise
    # Add a document to the index.
    document = {
        'title': 'Moneyball',
        'director': 'Bennett Miller',
        'year': '2011'
    }
    id = '1'
    response = client.index(
        index=index_name,
        body=document,
        id=id,
        refresh=True
    )
    # Perform bulk operations
    movies = '{ "index" : { "_index" : "my-dsl-index", "_id" : "2" } } \n { "title" : "Interstellar", "director" : "Christopher Nolan", "year" : "2014"} \n { "create" : { "_index" : "my-dsl-index", "_id" : "3" } } \n { "title" : "Star Trek Beyond", "director" : "Justin Lin", "year" : "2015"} \n { "update" : {"_id" : "3", "_index" : "my-dsl-index" } } \n { "doc" : {"year" : "2016"} }'
    client.bulk(movies)
    # Create an index with non-default settings.
    index_name = 'cpu_performance'
    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }

    try:
        # Your OpenSearch client and index creation code here
        response = client.indices.create(index_name, body=index_body)
        print(f"Index '{index_name}' created successfully.")
    except RequestError as e:
        if "resource_already_exists_exception" in str(e):
            print(f"Index '{index_name}' already exists.")
        else:
            # Handle other RequestError exceptions or re-raise the exception
            print(f"An error occurred: {e}")
            raise

    # Add documents to the index.
    data = generate_cpu_idle_data()

    for document in data:
        response = client.index(
            index=index_name,
            body=document,
            refresh=True
        )
        print('\nAdding document:')
        print(response)


def main():
    """Generate random data for OpenSearch."""
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
    wait_for_opensearch(client, timeout=60)
    write_data_in_opensearch(client)
    print('example_time_series_data.py: Finished example_time_series_data')


if __name__ == "__main__":
    main()
