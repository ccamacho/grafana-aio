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

from grafanalib.core import (
    Dashboard, Graph, GridPos,
    RowPanel, SHORT_FORMAT,
    YAxes, YAxis
)
from grafanalib.influxdb import InfluxDBTarget


dashboard = Dashboard(
    title="Jupyter notebooks tests",
    description="Execution times per image and scale tests",
    tags=[
        'jupyter_notebooks',
        'performance',
        'scale'
    ],
    timezone="browser",
    panels=[
        RowPanel(title="Performance tests", gridPos=GridPos(h=1, w=24, x=0, y=0)),
        Graph(
            title="Execution time per image",
            dataSource='influxdb-local',
            targets=[
                InfluxDBTarget(
                    query='SELECT "execution_time" FROM "autogen"."jupyter_notebooks_performance" GROUP BY "image"::tag ORDER BY time ASC',
                    rawQuery=True,
                ),
            ],
            gridPos=GridPos(h=8, w=24, x=0, y=1),
            yAxes=YAxes(
                YAxis(format=SHORT_FORMAT, label="Execution time"),
                YAxis(format=SHORT_FORMAT),
            ),
        ),
        RowPanel(title="Scale tests", gridPos=GridPos(h=1, w=24, x=0, y=9)),
        Graph(
            title="Scale tests per flavor",
            dataSource='influxdb-local',
            targets=[
                InfluxDBTarget(
                    query='SELECT "user_count" FROM "autogen"."jupyter_notebooks_scale" GROUP BY "test_flavor"::tag ORDER BY time ASC',
                    rawQuery=True,
                ),
            ],
            gridPos=GridPos(h=8, w=24, x=0, y=10),
            yAxes=YAxes(
                YAxis(format=SHORT_FORMAT, label="Users"),
                YAxis(format=SHORT_FORMAT),
            ),
        ),
    ],
).auto_panel_ids()
