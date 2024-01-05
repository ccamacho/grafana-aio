# dashboard.jsonnet
#
# Old version of grafonnet-lib
#
local grafana = import 'grafonnet/grafana.libsonnet';

grafana.dashboard.new(
    title='Grafonnet-lib and InfluxDB',
    # allow the user to make changes in Grafana
    editable=true,
    # avoid issues associated with importing multiple versions in Grafana
    schemaVersion=21,
).addPanel(
    grafana.graphPanel.new(
        title='My grafonnet latest only first graph',
        # demonstration data
        datasource='-- Grafana --'
    ),
    # panel position and size
    gridPos = { h: 8, w: 8, x: 0, y: 0 }
).addPanel(
    grafana.graphPanel.new(
        title='Pending requests',
        datasource='-- Grafana --',
        # Lowest displayed value
        min=0,
        # Left y-axis legend
        labelY1='pending',
        # Color intensity of the area under the graph
        fill=0,
        # Number of decimal places in values
        decimals=2,
        # Number of decimal places in left y-axis values
        decimalsY1=0,
        # Sort the values in decreasing order
        sort='decreasing',
        # Present the legend as a table
        legend_alignAsTable=true,
        # Display values in the legend
        legend_values=true,
        # Display the average value in the legend
        legend_avg=true,
        # Display the current value in the legend
        legend_current=true,
        # Display the maximum in the legend
        legend_max=true,
        # Sort by current value
        legend_sort='current',
        # Sort in descending order
        legend_sortDesc=true,
    ),
    gridPos = { h: 8, w: 16, x: 9, y: 0 }
).addPanel(
    grafana.graphPanel.new(
        title='My first graph',
        datasource='influxdb-local'
    ).addTarget(
        grafana.influxdb.target(
            query='SELECT value FROM autogen.cpu_idle WHERE value::field > 1 GROUP BY hostName::tag ORDER BY time ASC',
            rawQuery=true,
        )
    ),
    # panel position and size
    gridPos = { h: 8, w: 24, x: 0, y: 9 }
)
