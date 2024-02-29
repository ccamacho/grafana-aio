local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local fieldOverride = g.fieldOverride;

//
// Begin dashboard variables
//
local var = g.dashboard.variable;
// https://grafana.com/docs/grafana/latest/datasources/elasticsearch/template-variables/

local model_nameVar =
  var.query.new('model_name', '{"find": "terms",  "field": "model_name.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local concurrencyVar =
  var.query.new('concurrency', '{"find": "terms", "field": "concurrency", "query": "*"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local rhoai_versionVar =
  var.query.new('rhoai_version', '{"find": "terms",  "field": "rhoai_version.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local ocp_versionVar =
  var.query.new('ocp_version', '{"find": "terms",  "field": "ocp_version.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local gpu_modelVar =
  var.query.new('gpu_model', '{"find": "terms",  "field": "gpu_model.keyword"}')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-local',
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
    get_kserve_llm_load_test_tpot()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai-watsonx-multi__kserve_llm_load_test_tpot AND model_name:[[model_name]] AND concurrency:[[concurrency]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND gpu_model:[[gpu_model]]',
          alias: 'get_kserve_llm_load_test_tpot',
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
    get_kserve_llm_load_test_ttft()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai-watsonx-multi__kserve_llm_load_test_ttft AND model_name:[[model_name]] AND concurrency:[[concurrency]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND gpu_model:[[gpu_model]]',
          alias: 'get_kserve_llm_load_test_ttft',
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
    get_kserve_llm_load_test_model_load_duration()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai-watsonx-multi__kserve_llm_load_test_model_load_duration AND model_name:[[model_name]] AND concurrency:[[concurrency]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND gpu_model:[[gpu_model]]',
          alias: 'get_kserve_llm_load_test_model_load_duration',
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
    get_kserve_llm_load_test_throughput()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-local')
        + {
          query: '_index:rhoai-watsonx-multi__kserve_llm_load_test_throughput AND model_name:[[model_name]] AND concurrency:[[concurrency]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND gpu_model:[[gpu_model]]',
          alias: 'get_kserve_llm_load_test_throughput',
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
  groupByModelAndSort()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "concurrency"
              }
            ]
          }
        },
        {
          id: "convertFieldType",
          options: {
            fields: {},
            conversions: [
              {
                targetField: "concurrency",
                destinationType: "string"
              }
            ]
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "model_name",
            rowField: "concurrency",
            valueField: "value",
            emptyValue: "null"
          }
        },
      ]
    },
};


local myOverrides = {
  AxisAndModel()::
    {
    overrides: [
      {
        matcher: {
          id: "byName",
          options: "concurrency\\model_name"
        },
        properties: [
          {
            id: "custom.axisLabel",
            value: "Concurrency"
          }
        ]
      },
      {
        matcher: {
          id: "byName",
          options: "concurrency\\model_name"
        },
        properties: [
          {
            id: "unit",
            value: "users"
          }
        ]
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
      "title": "Performance distribution between the fastest benchmark runs",
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

    barChart(
        title='',
        description='',
        targets=[],
        transparent=false,
        unit=null,
        min=null,
        max=null,
        decimals=null,
        axisLabel='',
        legendMode='table',
        legendPlacement='right',
        legendCalcs=['max', 'min', 'mean', 'variance'],
        tooltipMode='multi',
        fillOpacity=6,
        gradientMode='opacity',
        axisWidth=null,
        thresholdMode=null,
        thresholdSteps=[],
        transformations={},
        overrides={},
    ):: g.panel.barChart.new(title)
        + transformations
        + g.panel.barChart.panelOptions.withDescription(description)
        + g.panel.barChart.queryOptions.withTargets(targets)
        + (if transparent then g.panel.barChart.panelOptions.withTransparent() else {})
        + g.panel.barChart.standardOptions.withUnit(unit)
        + g.panel.barChart.standardOptions.withMin(min)
        + g.panel.barChart.standardOptions.withMax(max)
        + g.panel.barChart.standardOptions.withDecimals(decimals)
        + g.panel.barChart.options.legend.withDisplayMode(legendMode)
        + g.panel.barChart.options.legend.withPlacement(legendPlacement)
        + g.panel.barChart.options.legend.withCalcs(legendCalcs)
        + g.panel.barChart.options.tooltip.withMode(tooltipMode)
        + g.panel.barChart.fieldConfig.defaults.custom.withFillOpacity(fillOpacity)
        + g.panel.barChart.fieldConfig.defaults.custom.withGradientMode(gradientMode)
        + g.panel.barChart.fieldConfig.defaults.custom.withAxisWidth(axisWidth)
        + g.panel.barChart.fieldConfig.defaults.custom.thresholdsStyle.withMode(thresholdMode)
        + g.panel.barChart.fieldConfig.defaults.custom.withAxisLabel(axisLabel)
        + g.panel.barChart.standardOptions.thresholds.withSteps(thresholdSteps)
        + g.panel.barChart.standardOptions.withOverrides(overrides),

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

local bchart ={
  kserve_llm_load_test_tpot:: panelo.barChart(
    title='Kserve LLM load test TPOT',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_tpot(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.groupByModelAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_ttft:: panelo.barChart(
    title='Kserve LLM load test TTFT',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_ttft(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.groupByModelAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_model_load_duration:: panelo.barChart(
    title='Kserve LLM load test duration',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_model_load_duration(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.groupByModelAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_throughput:: panelo.barChart(
    title='Kserve LLM load test throughput',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_throughput(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.groupByModelAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
};

local myPanels = {
  stateTimeline: statetime,
  timeSeries: timese,
  barChart: bchart,
};
//
// End panels definitions
//

//
// Begin dashboard definition
//
local w = g.panel.timeSeries.gridPos.withW;
local h = g.panel.timeSeries.gridPos.withH;

g.dashboard.new('Kserve LLM load tests')
+ g.dashboard.withDescription('Load test results for Kserve LLM')
+ g.dashboard.withRefresh('1m')
// This just stopped to work...
// + g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  model_nameVar,
  concurrencyVar,
  rhoai_versionVar,
  ocp_versionVar,
  gpu_modelVar,
])
+ g.dashboard.withPanels([
  myPanels.barChart.kserve_llm_load_test_tpot + w(24) + h(14),
  myPanels.barChart.kserve_llm_load_test_ttft + w(24) + h(14),
  myPanels.barChart.kserve_llm_load_test_model_load_duration + w(24) + h(14),
  myPanels.barChart.kserve_llm_load_test_throughput + w(24) + h(14),
])
//
// End dashboard definition
//
