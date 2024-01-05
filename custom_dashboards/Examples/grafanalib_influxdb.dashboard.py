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
    Dashboard, Graph, GridPos, RowPanel,
    SECONDS_FORMAT, SHORT_FORMAT,
    TimeSeries, YAxes, YAxis
)
from grafanalib.influxdb import InfluxDBTarget


dashboard = Dashboard(
    title="Grafanalib and InfluxDB",
    description="This is a example_time_series_data.dashboard",
    tags=[
        'example_time_series_data.dashboard'
    ],
    timezone="browser",
    panels=[
        RowPanel(title="This is a title row", gridPos=GridPos(h=1, w=24, x=0, y=8)),
        TimeSeries(
            title="CPU idle example",
            dataSource='influxdb-local',
            targets=[
                InfluxDBTarget(
                    query="SELECT value FROM autogen.cpu_idle WHERE value::field > 1 GROUP BY hostName::tag ORDER BY time ASC",
                    rawQuery=True,
                ),
            ],
            gridPos=GridPos(h=8, w=24, x=0, y=9),
            unit=SECONDS_FORMAT,
            legendPlacement="right",
            legendCalcs=["min", "mean", "max", "range"],
            legendDisplayMode="table",
        ),
        Graph(
            title="CPU Usage by Namespace (rate[5m])",
            dataSource='influxdb-local',
            targets=[
                InfluxDBTarget(
                    query="SELECT value FROM autogen.cpu_idle WHERE value::field > 1 GROUP BY hostName::tag ORDER BY time ASC",
                    rawQuery=True,
                ),
            ],
            gridPos=GridPos(h=8, w=24, x=0, y=17),
            yAxes=YAxes(
                YAxis(format=SHORT_FORMAT, label="CPU seconds"),
                YAxis(format=SHORT_FORMAT),
            ),
        ),
        Graph(
            title="CPU idle per target",
            dataSource='influxdb-local',
            targets=[
                InfluxDBTarget(
                    alias="image-1",
                    query="SELECT value FROM autogen.cpu_idle WHERE hostName::tag = 'image-1' ORDER BY time ASC",
                    rawQuery=True,
                ),
                InfluxDBTarget(
                    alias="image-2",
                    query="SELECT value FROM autogen.cpu_idle WHERE hostName::tag = 'image-2' ORDER BY time ASC",
                    rawQuery=True,
                ),
                InfluxDBTarget(
                    alias="image-3",
                    query="SELECT value FROM autogen.cpu_idle WHERE hostName::tag = 'image-3' ORDER BY time ASC",
                    rawQuery=True,
                ),
                InfluxDBTarget(
                    alias="image-4",
                    query="SELECT value FROM autogen.cpu_idle WHERE hostName::tag = 'image-4' ORDER BY time ASC",
                    rawQuery=True,
                ),
                InfluxDBTarget(
                    alias="image-5",
                    query="SELECT value FROM autogen.cpu_idle WHERE hostName::tag = 'image-5' ORDER BY time ASC",
                    rawQuery=True,
                ),
            ],
            gridPos=GridPos(h=8, w=24, x=0, y=25),
            yAxes=YAxes(
                YAxis(format=SHORT_FORMAT, label="CPU seconds"),
                YAxis(format=SHORT_FORMAT),
            ),
        ),
    ],
).auto_panel_ids()

# Manually modify the alias for the desired target
for panel in dashboard.panels:
    if isinstance(panel, TimeSeries):
        for target in panel.targets:
            if isinstance(target, InfluxDBTarget):
                break
                target.alias = "CPU idle records - {{hostName}}"
