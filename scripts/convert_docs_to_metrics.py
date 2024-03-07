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
import os
import json


def convert_llama_data():
    """Convert data from JSON files to a metrics format."""
    source_data_folder = './datasets/llama-13b'
    csv_file_path = './datasets/llama-13b/llama-13b.csv'

    with open(csv_file_path, 'w', newline='') as csvfile:
        fieldnames = ['user_id',
                      'input_text',
                      'input_tokens',
                      'output_text',
                      'output_tokens',
                      'start_time',
                      'ack_time',
                      'first_token_time',
                      'end_time',
                      'response_time',
                      'tt_ack',
                      'ttft',
                      'tpot',
                      'error_code',
                      'error_text',
                      'max_queries',
                      'max_input_tokens',
                      'max_output_tokens',
                      'load_options_concurrency',
                      'load_options_duration',
                      'plugin',
                      'plugin_options_streaming',
                      'plugin_options_model_name',
                      'extra_metadata_replicas']
        
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()

        for filename in os.listdir(source_data_folder):
            if filename.endswith('.json'):
                with open(os.path.join(source_data_folder, filename), 'r') as file:
                    data = json.load(file)
                    for result in data.get('results', []):
                        row_data = {
                            'user_id': result.get('user_id', ''),
                            'input_text': result.get('input_text', '')[:10] + "...",
                            'input_tokens': result.get('input_tokens', ''),
                            'output_text': result.get('output_text', '')[:10] + "...",
                            'output_tokens': result.get('output_tokens', ''),
                            'start_time': result.get('start_time', ''),
                            'ack_time': result.get('ack_time', ''),
                            'first_token_time': result.get('first_token_time', ''),
                            'end_time': result.get('end_time', ''),
                            'response_time': result.get('response_time', ''),
                            'tt_ack': result.get('tt_ack', ''),
                            'ttft': result.get('ttft', ''),
                            'tpot': result.get('tpot', ''),
                            'error_code': result.get('error_code', ''),
                            'error_text': result.get('error_text', ''),
                        }
                        config = data.get('config', {})
                        row_data.update({
                            'max_queries': config['dataset'].get('max_queries', ''),
                            'max_input_tokens': config['dataset'].get('max_input_tokens', ''),
                            'max_output_tokens': config['dataset'].get('max_output_tokens', ''),
                            'load_options_concurrency': config['load_options'].get('concurrency', ''),
                            'load_options_duration': config['load_options'].get('duration', ''),
                            'plugin': config.get('plugin', ''),
                            'plugin_options_streaming': config['plugin_options'].get('streaming', ''),
                            'plugin_options_model_name': config['plugin_options'].get('model_name', ''),
                            'extra_metadata_replicas': config['extra_metadata'].get('replicas', ''),
                        })
                        writer.writerow(row_data)

def main():
    """Import mock data in InfluxDB."""
    convert_llama_data()
    print('example_time_series_data.py: Finished example_time_series_data')


if __name__ == "__main__":
    main()
