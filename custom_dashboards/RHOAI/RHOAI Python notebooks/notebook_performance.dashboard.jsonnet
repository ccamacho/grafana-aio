local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

//
// Begin dashboard variables
//
local var = g.dashboard.variable;

local rhoai_versionVar =
  var.query.new('rhoai_version', '{"find": "terms",  "field": "rhoai_version.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local imageVar =
  var.query.new('image', '{"find": "terms",  "field": "image.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local image_nameVar =
  var.query.new('image_name', '{"find": "terms",  "field": "image_name.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local image_tagVar =
  var.query.new('image_tag', '{"find": "terms",  "field": "image_tag.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();
//
// End dashboard variables
//

//
// Begin dashboard queries
//
local opensearch_queries = {
    getPythonNotebooksMin()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:notebook_performance_benchmark_min_time AND rhoai_version:[[rhoai_version]] AND image:[[image]] AND image_name:[[image_name]] AND image_tag:[[image_tag]]',
          alias: 'getPythonNotebooksMin',
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
    getPythonNotebooksMinMaxDiff()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:notebook_performance_benchmark_min_max_diff AND rhoai_version:[[rhoai_version]] AND image:[[image]] AND image_name:[[image_name]] AND image_tag:[[image_tag]]',
          alias: 'getPythonNotebooksMinMaxDiff',
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
    getPythonNotebooksMeasures()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:notebook_performance_benchmark_time AND rhoai_version:[[rhoai_version]] AND image:[[image]] AND image_name:[[image_name]] AND image_tag:[[image_tag]]',
          alias: 'getPythonNotebooksMeasures',
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
//
// End dashboard queries
//

//
// Begin define transformations
//
local myTransformations = {
  filterTestFieldNames()::
    {
      transformations: [
        {
          id: "filterFieldsByName",
          options: {
            byVariable: false,
            include: {
              names: [
                "@timestamp",
                "_type",
                "image",
                "image_name",
                "image_tag",
                "instance_type",
                "ocp_version",
                "rhoai_version",
                "value"
              ]
            }
          }
        }
      ]
    },
  groupByImage()::
    {
      transformations: [
        {
          id: "groupingToMatrix",
          options: {
            columnField: "image_name",
            rowField: "image_tag",
            valueField: "value",
            emptyValue: "null"
          }
        }
      ]
    },
  extractMeasures()::
    {
      transformations: [
        {
          id: "extractFields",
          options: {
            format: "kvp",
            keepTime: false,
            replace: false,
            source: "value"
          }
        }
      ]
    },
};
//
// End define transformations
//

//
// Begin Plotly boxplot
//
local plotly_boxplot = {
  get_labelsEvolution()::
    {
      "title": "Minimum execution times distribution per image names and tags",
      "type": "nline-plotlyjs-panel",
      "datasource": {
        "type": "opensearch",
        "uid": "opensearch-remote"
      },
      "transformations": myTransformations.groupByImage().transformations,
      "targets": [
        opensearch_queries.getPythonNotebooksMin()
      ],
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
        "onclick": |||
            // console.log(data);
            // locationService.partial({ 'var-example': 'test' }, true);
        |||,
        "resScale": 2,
        "script": |||
          var dataTraces = [];
          for (var i = 1; i < data.series[0].fields.length; i++) {
            var colorR = getRandomColor()
            var fills = data.series[0].fields[i].name
            var trace = {
              name: data.series[0].fields[i].name,
              line: {
                color: colorR,
                width: 1
              },
              y: data.series[0].fields[i].values,
              type: 'box',
              fill: 'toself',
              fillcolor: applyOpacityToColor(colorR),
              boxpoints: 'all',
              text: "asdf",
            };
            dataTraces.push(trace);
          }
          function getRandomColor() {
            var color = [
              Math.floor(Math.random() * 256),
              Math.floor(Math.random() * 256),
              Math.floor(Math.random() * 256)
            ];
            return "rgba(" + color.join(",") + ",1)";
          }
          function applyOpacityToColor(color, opacity) {
            const rgbaValues = color.match(/\d+/g).map(Number);
            rgbaValues[3] = opacity;
            return `rgba(${rgbaValues.join(",")})`;
          }
          return { data: dataTraces };
        |||,
        "timeCol": "",
        "yamlMode": false
      },
    },  
  
};
//
// End Plotly boxplot
//

//
// Begin panels difinitions
//
local panelo = {
    stateTimeline(
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
        fillOpacity=6,
        thresholdSteps=[],
        rowHeight=0.8,
        lineWidth=0,
        alignValue='center',
        transformations={},
    ):: g.panel.stateTimeline.new(title)
        + transformations
        + g.panel.stateTimeline.panelOptions.withDescription(description)
        + g.panel.stateTimeline.queryOptions.withTargets(targets)
        + (if transparent then g.panel.stateTimeline.panelOptions.withTransparent() else {})
        + g.panel.stateTimeline.standardOptions.withUnit(unit)
        + g.panel.stateTimeline.standardOptions.withMin(min)
        + g.panel.stateTimeline.standardOptions.withMax(max)
        + g.panel.stateTimeline.standardOptions.withDecimals(decimals)
        + g.panel.stateTimeline.options.legend.withDisplayMode(legendMode)
        + g.panel.stateTimeline.options.legend.withPlacement(legendPlacement)
        + g.panel.stateTimeline.options.tooltip.withMode(tooltipMode)
        + g.panel.stateTimeline.options.withRowHeight(rowHeight)
        + g.panel.stateTimeline.options.withAlignValue(alignValue)
        + g.panel.stateTimeline.fieldConfig.defaults.custom.withFillOpacity(fillOpacity)
        + g.panel.stateTimeline.standardOptions.thresholds.withSteps(thresholdSteps)
        + g.panel.stateTimeline.fieldConfig.defaults.custom.withLineWidth(lineWidth),

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
        drawStyle='points',
        thresholdMode=null,
        thresholdSteps=[],
        transformations={},
    ):: g.panel.timeSeries.new(title)
        + transformations
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
};
//
// End panels difinitions
//

//
// Begin panels definitions
//
local statetime ={
  notebookPerfMin:: panelo.stateTimeline(
    title='Minimum execution time',
    targets=[
      opensearch_queries.getPythonNotebooksMin(),
    ],
    min=0,
    // unit='s',
    decimals=4,
    legendPlacement='left',
    fillOpacity=60,
    transformations = myTransformations.filterTestFieldNames()
  ),
};

local timese ={
  notebookPerfMinMaxDiff:: panelo.timeSeries(
    title='Difference between min and max',
    targets=[
      opensearch_queries.getPythonNotebooksMinMaxDiff(),
    ],
    min=0,
    unit='ms',
    decimals=8,
    legendPlacement='bottom',
    stackingMode='normal',
    fillOpacity=60,
    gradientMode=null,
    transformations ={}
  ),
  notebookPerfMeasures:: panelo.timeSeries(
    title='Time series measures',
    targets=[
      opensearch_queries.getPythonNotebooksMeasures(),
    ],
    min=0,
    unit='ms',
    decimals=8,
    legendPlacement='bottom',
    stackingMode='normal',
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.extractMeasures()
  ),
};

local myPanels = {
  stateTimeline: statetime,
  timeSeries: timese,
};
//
// End panels definitions
//

//
// Begin dashboard definition
//
local w = g.panel.timeSeries.gridPos.withW;
local h = g.panel.timeSeries.gridPos.withH;

g.dashboard.new('Python notebooks performance dashboard')
+ g.dashboard.withDescription('Performance tests for the Python notebooks')
+ g.dashboard.withRefresh('1m')
// This just stopped to work...
// + g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  rhoai_versionVar,
  imageVar,
  image_nameVar,
  image_tagVar,
])
+ g.dashboard.withPanels([
  myPanels.stateTimeline.notebookPerfMin + w(24) + h(10),
  myPanels.timeSeries.notebookPerfMinMaxDiff + w(24) + h(10),
  myPanels.timeSeries.notebookPerfMeasures + w(24) + h(10),
  plotly_boxplot.get_labelsEvolution() + w(24) + h(14),
])
//
// End dashboard definition
//
