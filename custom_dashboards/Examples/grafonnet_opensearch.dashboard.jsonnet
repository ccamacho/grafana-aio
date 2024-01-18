local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local opensearch_queries = {
    get_accuracy():: 
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai_perfdata_accuracy',
          alias: 'get_accuracyQuery',
          queryType: "lucene",
          metrics: [
            {
              type: "raw_data",
            }
          ],
          format: "table",
          timeField: "@timestamp",
          luceneQueryType: "Metric",
        },
    get_throughput():: 
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai_perfdata_throughput',
          alias: 'get_throughputQuery',
          queryType: "lucene",
          metrics: [
            {
              type: "raw_data",
            }
          ],
          format: "table",
          timeField: "@timestamp",
          luceneQueryType: "Metric",
        },
    get_boxplot_latency():: 
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai_perfdata_latency AND Image:[[imageVariable]]',
          alias: 'get_boxplot_latency',
          queryType: "lucene",
          metrics: [
            {
              type: "raw_data",
            }
          ],
          format: "table",
          timeField: "@timestamp",
          luceneQueryType: "Metric",
        },
};

local plotly_boxplot = {
  get_asdf()::
{
      "datasource": {
        "type": "opensearch",
        "uid": "opensearch-local"
      },
      "gridPos": {
        "h": 8,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "id": 2,
      "options": {
        "allData": {},
        "config": {},
        "data": [],
        "imgFormat": "png",
        "layout": {
          "font": {
            "color": "white",
            "family": "Inter, Helvetica, Arial, sans-serif"
          },
          "hoverlabel": {
            "bgcolor": "transparent"
          },
          "paper_bgcolor": "transparent",
          "plot_bgcolor": "transparent",
          "xaxis": {
            "automargin": true,
            "autorange": true,
            "type": "-"
          },
          "yaxis": {
            "automargin": true,
            "autorange": true
          }
        },
        "onclick": "// console.log(data);\n// locationService.partial({ 'var-example': 'test' }, true);\n  ",
        "resScale": 2,
        "script": "var trace = {\n  name: data.series[0].fields[2].name,\n  line: {\n      color: \"rgba(134, 107, 64, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[2].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(134, 107, 64, .2)',\n  boxpoints: 'all'\n\n};\n\nvar trace2 = {\n  name: data.series[0].fields[3].name,\n  line: {\n      color: \"rgba(250, 222, 42, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[3].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(250, 222, 42, .2)',\n  boxpoints: 'all'\n};\n\nvar trace3 = {\n  name: data.series[0].fields[4].name,\n  line: {\n      color: \"rgba(115, 191, 105, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[4].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(115, 191, 105, .2)',\n  boxpoints: 'all'\n};\n\nvar trace4 = {\n  name: data.series[0].fields[5].name,\n  line: {\n      color: \"rgba(87, 148, 242, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[5].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(87, 148, 242, .2)',\n  boxpoints: 'all'\n};\n\nvar trace5 = {\n  name: data.series[0].fields[6].name,\n  line: {\n      color: \"rgba(142, 142, 142, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[6].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(142, 142, 142, .2)',\n  boxpoints: 'all'\n};\n\nvar trace6 = {\n  name: data.series[0].fields[7].name,\n  line: {\n      color: \"rgba(242, 73, 92, 1)\",\n      width: 1\n    },\n  y: data.series[0].fields[7].values,\n  type: 'box',\n  fill: 'toself',\n  fillcolor: 'rgba(242, 73, 92, .2)',\n  boxpoints: 'all'\n};\n\n\ndata = [trace,trace2,trace3,trace4,trace5,trace6];\n\nreturn {data};",
        "timeCol": "",
        "yamlMode": false
      },
      "targets": [
        opensearch_queries.get_boxplot_latency()
      ],
      "title": "Latency",
      "type": "nline-plotlyjs-panel"
    },  
  
};






local panelo = {
    timeSeries(
        title='',
        description='',
        targets=[],
        transparent=false,
        unit=null,
        min=null,
        max=null,
        decimals=null,
        legendMode='list',
        legendPlacement='right',
        tooltipMode='multi',
        stackingMode=null,
        fillOpacity=6,
        gradientMode='opacity',
        axisWidth=null,
        drawStyle=null,
        thresholdMode=null,
        thresholdSteps=[],
    ):: g.panel.timeSeries.new(title)
        + g.panel.timeSeries.panelOptions.withDescription(description)
        + g.panel.timeSeries.queryOptions.withTargets(targets)
        + (if transparent then g.panel.timeSeries.panelOptions.withTransparent() else {})
        + g.panel.timeSeries.standardOptions.withUnit(unit)
        + g.panel.timeSeries.standardOptions.withMin(min)
        + g.panel.timeSeries.standardOptions.withMax(max)
        + g.panel.timeSeries.standardOptions.withDecimals(decimals)
        + g.panel.timeSeries.options.legend.withDisplayMode(legendMode)
        + g.panel.timeSeries.options.legend.withPlacement(legendPlacement)
        + g.panel.timeSeries.options.tooltip.withMode(tooltipMode)
        + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode(stackingMode)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(fillOpacity)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withGradientMode(gradientMode)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisWidth(axisWidth)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle(drawStyle)
        + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode(thresholdMode)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps(thresholdSteps),

    barChart(
        title='',
        description='',
        targets=[],
        transparent=false,
        legendMode='list',
        legendPlacement='right',
    ):: g.panel.barChart.new(title)
        + g.panel.barChart.panelOptions.withDescription(description)
        + g.panel.barChart.options.legend.withDisplayMode(legendMode)
        + g.panel.barChart.options.legend.withPlacement(legendPlacement)
        + g.panel.barChart.queryOptions.withTargets(targets)
        + (if transparent then g.panel.barChart.panelOptions.withTransparent() else {})
        + g.panel.barChart.fieldConfig.defaults.custom.scaleDistribution.withLog(10)
        + g.panel.barChart.fieldConfig.defaults.custom.scaleDistribution.withType("log"), //valid values: "linear", "log", "ordinal", "symlog"

    stat(
        title='',
        description='',
        targets=[],
        transparent=false,
        unit=null,
        colorMode=null
    ):: g.panel.stat.new(title)
        + g.panel.stat.panelOptions.withDescription(description)
        + g.panel.stat.queryOptions.withTargets(targets)
        + (if transparent then g.panel.gauge.panelOptions.withTransparent() else {})
        + g.panel.stat.standardOptions.withUnit(unit)
        + g.panel.stat.options.withColorMode(colorMode),
    
    gauge(
        title='',
        description='',
        targets=[],
        transparent=false,
        unit=null,
        min=null,
        max=null,
        decimals=null,
        thresholdMode=null,
        thresholdSteps=[],
    ):: g.panel.gauge.new(title)
        + g.panel.gauge.panelOptions.withDescription(description)
        + g.panel.gauge.queryOptions.withTargets(targets)
        + (if transparent then g.panel.gauge.panelOptions.withTransparent() else {})
        + g.panel.gauge.standardOptions.withUnit(unit)
        + g.panel.gauge.standardOptions.withMin(min)
        + g.panel.gauge.standardOptions.withMax(max)
        + g.panel.gauge.standardOptions.withDecimals(decimals)
        + g.panel.gauge.standardOptions.thresholds.withMode(thresholdMode)
        + g.panel.gauge.standardOptions.thresholds.withSteps(thresholdSteps),
    barGauge(
        title='',
        description='',
        targets=[],
        transparent=false,
        unit=null,
        min=null,
        max=null,
        decimals=null,
        displayMode=null,
        orientation=null,
        thresholdMode=null,
        thresholdSteps=[],
    ):: g.panel.barGauge.new(title)
        + g.panel.barGauge.panelOptions.withDescription(description)
        + g.panel.barGauge.queryOptions.withTargets(targets)
        + (if transparent then g.panel.barGauge.panelOptions.withTransparent() else {})
        + g.panel.barGauge.standardOptions.withUnit(unit)
        + g.panel.barGauge.standardOptions.withMin(min)
        + g.panel.barGauge.standardOptions.withMax(max)
        + g.panel.barGauge.standardOptions.withDecimals(decimals)
        + g.panel.barGauge.options.withDisplayMode(displayMode)
        + g.panel.barGauge.options.withOrientation(orientation)
        + g.panel.barGauge.standardOptions.thresholds.withMode(thresholdMode)
        + g.panel.barGauge.standardOptions.thresholds.withSteps(thresholdSteps),
};

local timese ={
  usersPerNamespace:: panelo.timeSeries(
    title='Accuracy',
    targets=[
      opensearch_queries.get_accuracy(),
    ],
    min=0,
    decimals=0,
    legendPlacement='right',
    stackingMode='normal',
    fillOpacity=60,
    gradientMode=null
  ),
};

local get_throughput_barchart ={
  thoru:: panelo.barChart(
    title='Throughput',
    targets=[
      opensearch_queries.get_throughput(),
    ]
  ),
};

// local asdf ={
//   getyio:: panelo.timeSeries(
//     title='Accuracy',
//     targets=[
//       opensearch_queries.get_accuracy(),
//     ],
//     min=0,
//     decimals=0,
//     legendPlacement='right',
//     stackingMode='normal',
//     fillOpacity=60,
//     gradientMode=null
//   ),
// };


local var = g.dashboard.variable;
// https://docs.aws.amazon.com/grafana/latest/userguide/using-opensearch-in-AMG.html
local customVar =
  var.custom.new(
    'myOptions',
    values=['a', 'b', 'c', 'd'],
  )
  + var.custom.generalOptions.withDescription(
    'This is a variable for my custom options.'
  )
  + var.custom.selectionOptions.withMulti();

local queryVar =
  var.query.new('imageVariable', '{"find": "terms",  "field": "Image.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();


local myPanels = {
  barChart: get_throughput_barchart,
  timeSeries: timese,
};

local w = g.panel.timeSeries.gridPos.withW;
local h = g.panel.timeSeries.gridPos.withH;

g.dashboard.new('Grafonnet and OpenSearch example: Benchmarks results')
+ g.dashboard.withUid('grafonnet-opensearch--')
+ g.dashboard.withDescription('Simple Grafonnet and OpenSearch example')
+ g.dashboard.withRefresh('1m')
+ g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  customVar,
  queryVar,
])
+ g.dashboard.withPanels([
  myPanels.timeSeries.usersPerNamespace + w(24) + h(10),
  myPanels.barChart.thoru + w(24) + h(10),
  plotly_boxplot.get_asdf() + w(24) + h(10),
])
