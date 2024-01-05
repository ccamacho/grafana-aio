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

from horreum_data_import import main as horreum_data_import_main

from influxdb_example_time_series_data import main as influxdb_example_time_series_data_main

from opensearch_example_data import main as opensearch_example_data_main


def main():
    """Run the InfluxDB synchronization scripts."""
    influxdb_example_time_series_data_main()
    opensearch_example_data_main()
    print("syncdata.py: Example time series executed")
    horreum_data_import_main()
    print("syncdata.py: File horreum sync executed")
    print("syncdata.py: File 'influxdb_syncdata' executed")


if __name__ == "__main__":
    main()
