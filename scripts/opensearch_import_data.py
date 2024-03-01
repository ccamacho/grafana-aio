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
import time
import random
from datetime import datetime, timedelta

from opensearchpy import OpenSearch
from opensearchpy.exceptions import AuthorizationException

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

def opensearch_write_llama_13b(client):
    """Write llama13b data in OpenSearch."""
    index_name = 'rhoai_perfdata_llama13b'
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
    data_path = os.path.join(current_working_directory, 'scripts/datasets/llama-13b/llama-13b.csv')
    with open(data_path, 'r') as file:
        csv_reader = csv.reader(file)
        header = next(csv_reader)
        print(header)
        for row in csv_reader:
            now = datetime.today()

            # Calculate throughput
            duration = float(row[8]) - float(row[5])  # end_time - start_time
            output_tokens_sum = int(row[4])  # Sum of output_tokens
            throughput = output_tokens_sum / duration if duration != 0 else 0

            document = {
                "@timestamp": now.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                'user_id': int(row[0]) if len(row) > 0 and row[0] != "" else None,
                'input_text': str(row[1]) if len(row) > 1 and row[1] != "" else None,
                'input_tokens': int(row[2]) if len(row) > 2 and row[2] != "" else None,
                'output_text': str(row[3]) if len(row) > 3 and row[3] != "" else None,
                'output_tokens': int(row[4]) if len(row) > 4 and row[4] != "" else None,
                'start_time': float(row[5]) if len(row) > 5 and row[5] != "" else None,
                'ack_time': float(row[6]) if len(row) > 6 and row[6] != "" else None,
                'first_token_time': float(row[7]) if len(row) > 7 and row[7] != "" else None,
                'end_time': float(row[8]) if len(row) > 8 and row[8] != "" else None,
                'response_time': float(row[9]) if len(row) > 9 and row[9] != "" else None,
                'tt_ack': float(row[10]) if len(row) > 10 and row[10] != "" else None,
                'ttft': float(row[11]) if len(row) > 11 and row[11] != "" else None,
                'tpot': float(row[12]) if len(row) > 12 and row[12] != "" else None,
                'error_code': int(row[13]) if len(row) > 13 and row[13] != "" else None,
                'error_text': str(row[14]) if len(row) > 14 and row[14] != "" else None,
                'max_queries': int(row[15]) if len(row) > 15 and row[15] != "" else None,
                'max_input_tokens': int(row[16]) if len(row) > 16 and row[16] != "" else None,
                'max_output_tokens': int(row[17]) if len(row) > 17 and row[17] != "" else None,
                'load_options_concurrency': int(row[18]) if len(row) > 18 and row[18] != "" else None,
                'load_options_duration': int(row[19]) if len(row) > 19 and row[19] != "" else None,
                'plugin': str(row[20]) if len(row) > 20 and row[20] != "" else None,
                'plugin_options_streaming': str(row[21]) if len(row) > 21 and row[21] != "" else None,
                'plugin_options_model_name': str(row[22]) if len(row) > 22 and row[22] != "" else None,
                'extra_metadata_replicas': int(row[23]) if len(row) > 23 and row[23] != "" else None,
                'throughput': float(throughput),
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


def opensearch_generate_models_data(client):
    """Generate models data in OpenSearch."""

    model_names = ['bigcode_starcoder',
                   #'bigscience_mt0-xxl',
                   #'eleutherai_gpt-neox-20b',
                   #'elyza_elyza-japanese-llama-2-7b-instruct',
                   #'google_flan-t5-xl',
                   #'google_flan-t5-xxl',
                   'google_flan-ul2',
                   'meta-llama_llama-2-13b-chat',
                   'meta-llama_llama-2-70b-chat']
    virtual_users= [1, 2, 16] #, 32, 64, 96]
    kpis = ["kserve_llm_load_test_tpot",
            #"kserve_llm_load_test_tpot_min",
            #"kserve_llm_load_test_tpot_max",
            #"kserve_llm_load_test_tpot_median",
            #"kserve_llm_load_test_tpot_mean",
            #"kserve_llm_load_test_tpot_p80",
            #"kserve_llm_load_test_tpot_p90",
            #"kserve_llm_load_test_tpot_p95",
            #"kserve_llm_load_test_tpot_p99",
            "kserve_llm_load_test_ttft",
            #"kserve_llm_load_test_ttft_min",
            #"kserve_llm_load_test_ttft_max",
            #"kserve_llm_load_test_ttft_median",
            #"kserve_llm_load_test_ttft_mean",
            #"kserve_llm_load_test_ttft_p80",
            #"kserve_llm_load_test_ttft_p90",
            #"kserve_llm_load_test_ttft_p95",
            #"kserve_llm_load_test_ttft_p99",
            "kserve_llm_load_test_model_load_duration",
            "kserve_llm_load_test_throughput"]

    # psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_tpot
    # psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_ttft
    # psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_model_load_duration
    # psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_throughput

    release_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        },
        'mappings': {
            'properties': {
                '@timestamp': {'type': 'date'},
                'software': {'type': 'keyword'},
                'tags': {'type': 'keyword'},
                'version': {'type': 'keyword'}
            }
        }
    }

    # Check if the index already exists
    index_name = 'rhoai_releases'
    if not client.indices.exists(index=index_name):
        client.indices.create(index=index_name, body=release_body)
        print(f"Index '{index_name}' created.")
    else:
        print(f"Index '{index_name}' already exists.")
        
    releases = [
        {
            "@timestamp": "2023-01-24T00:00:00.000Z",
            "software": "OCP",
            "version": "4.10"
        },
        {
            "@timestamp": "2023-04-24T00:00:00.000Z",
            "software": "OCP",
            "version": "4.11"
        },
        {
            "@timestamp": "2023-08-24T00:00:00.000Z",
            "software": "OCP",
            "version": "4.12"
        },
        {
            "@timestamp": "2023-12-24T00:00:00.000Z",
            "software": "OCP",
            "version": "4.13"
        },
        {
            "@timestamp": "2024-01-24T00:00:00.000Z",
            "software": "OCP",
            "version": "4.14"
        },
        {
            "@timestamp": "2024-03-04T00:00:00.000Z",
            "software": "OCP",
            "version": "4.15"
        },
        {
            "@timestamp": "2023-01-01T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.10"
        },
        {
            "@timestamp": "2023-04-01T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.11"
        },
        {
            "@timestamp": "2023-08-01T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.12"
        },
        {
            "@timestamp": "2023-12-01T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.13"
        },
        {
            "@timestamp": "2024-03-04T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.14"
        },
        {
            "@timestamp": "2024-03-01T00:00:00.000Z",
            "software": "RHODS",
            "version": "2.4.15"
        },
    ]
    for release in releases:
        client.index(index=index_name, body=release, refresh=True)
        print(f"Document inserted: {release}")

    index_body = {
        'settings': {
            'index': {
                'number_of_shards': 4
            }
        }
    }

    start_date = datetime(2023, 1, 1)
    end_date = datetime.now()

    for model_idx, model_name in enumerate(model_names):
        for kpi_idx, kpi in enumerate(kpis):
            index_name = f'psap-rhoai.watsonx-kserve-single-light__{kpi}'

            # Check if the index already exists
            if not client.indices.exists(index=index_name):
                client.indices.create(index=index_name, body=index_body)
                print(f"Index '{index_name}' created.")
            else:
                print(f"Index '{index_name}' already exists.")

            current_date = start_date
            while current_date <= end_date:
                for hour in [20]: # for hour in [8, 20]
                    timestamp = current_date.replace(hour=hour, minute=0, second=0, microsecond=0)

                    # Calculate adjustment factors
                    model_adjustment = model_idx * 20
                    kpi_adjustment = kpi_idx * 10

                    for virtual_users_val in virtual_users:
                        virtual_users_adjustment = int(virtual_users_val) * 5
                        
                        document = {
                            "@timestamp": timestamp.strftime('%Y-%m-%dT%H:%M:%S.%fZ'),
                            "value": float(random.uniform(0.85 + model_adjustment + kpi_adjustment + virtual_users_adjustment, 0.92 + model_adjustment + kpi_adjustment + virtual_users_adjustment)),
                            "model_name": str(model_name),
                            "virtual_users": int(virtual_users_val),
                            "rhoai_version": "3.45.1rc2",
                            "ocp_version": "4.15",
                            "accelerator_name": "DGX A100"
                        }
                        client.index(
                            index=index_name,
                            body=document,
                            refresh=True
                        )
                # We run the tests every week        
                current_date += timedelta(days=7)


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

    try:
        opensearch_write_accuracy(client)
        opensearch_write_latency(client)
        opensearch_write_loss(client)
        opensearch_write_throughput(client)
        opensearch_write_llama_13b(client)
        opensearch_generate_models_data(client)
    except AuthorizationException as e:
        print(f"Failed to create index: {e}")
        print("Check there is space on disk")

    client.close()
    print('example_time_series_data.py: Finished example_time_series_data')

    with open(script_executed, 'w') as flag_file:
        flag_file.write("Executed")


if __name__ == "__main__":
    main()
