local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local fieldOverride = g.fieldOverride;

//
// Begin dashboard variables
//
local var = g.dashboard.variable;
// https://grafana.com/docs/grafana/latest/datasources/elasticsearch/template-variables/

local model_nameVar =
  var.query.new('model_name', '{"find": "terms",  "field": "model_name.keyword"}')
  + var.query.withRegex('.+')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local virtual_usersVar =
  var.query.new('virtual_users', '{"find": "terms", "field": "virtual_users", "query": "*"}')
  + var.query.withRegex('.+')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local rhoai_versionVar =
  var.query.new('rhoai_version', '{"find": "terms",  "field": "rhoai_version.keyword"}')
  + var.query.withRegex('.+')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local ocp_versionVar =
  var.query.new('ocp_version', '{"find": "terms",  "field": "ocp_version.keyword"}')
  + var.query.withRegex('.+')
  + var.query.withDatasource(
    type='opensearch',
    uid='opensearch-remote',
  )
  + var.query.selectionOptions.withIncludeAll()
  + var.custom.selectionOptions.withMulti();

local accelerator_nameVar =
  var.query.new('accelerator_name', '{"find": "terms",  "field": "accelerator_name.keyword"}')
  + var.query.withRegex('.+')
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


    get_kserve_llm_load_test_failures()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_failures AND model_name:[[model_name]] AND virtual_users:[[virtual_users]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND accelerator_name:[[accelerator_name]]',
          alias: 'get_kserve_llm_load_test_failures',
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
    get_kserve_llm_load_test_tpot_min()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_tpot_min AND model_name:[[model_name]] AND virtual_users:[[virtual_users]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND accelerator_name:[[accelerator_name]]',
          alias: 'get_kserve_llm_load_test_tpot_min',
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
    get_kserve_llm_load_test_ttft_min()::
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_ttft_min AND model_name:[[model_name]] AND virtual_users:[[virtual_users]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND accelerator_name:[[accelerator_name]]',
          alias: 'get_kserve_llm_load_test_ttft_min',
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
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_model_load_duration AND model_name:[[model_name]] AND virtual_users:[[virtual_users]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND accelerator_name:[[accelerator_name]]',
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
        g.panel.timeSeries.queryOptions.withDatasource('opensearch', 'opensearch-remote')
        + {
          query: '_index:psap-rhoai.watsonx-kserve-single-light__kserve_llm_load_test_throughput AND model_name:[[model_name]] AND virtual_users:[[virtual_users]] AND rhoai_version:[[rhoai_version]] AND ocp_version:[[ocp_version]] AND accelerator_name:[[accelerator_name]]',
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
// Begin dashboard annotations
//
local annot = g.dashboard.annotation;

local rhods_annotation =
  annot.withEnable(true)
  + annot.withName("RHODS releases")
  + annot.withIconColor("#ec5353")
  + annot.withDatasource('opensearch-local')
  + annot.filter.withExclude(value=false)
  + annot.filter.withIds(12)
  + {
    query: "_index:rhoai_releases AND software:RHODS",
    target: {
      query: "_index:rhoai_releases",
      refId: "annotation_query"
    },
    tagsField: "version",
    textField: "software",
    timeField: "@timestamp"
  };

local ocp_annotation =
  annot.withEnable(true)
  + annot.withName("OCP releases")
  + annot.withIconColor("#00aaff")
  + annot.withDatasource('opensearch-local')
  + annot.filter.withExclude(value=false)
  + annot.filter.withIds(12)
  + {
    query: "_index:rhoai_releases AND software:OCP",
    target: {
      query: "_index:rhoai_releases",
      refId: "annotation_query"
    },
    tagsField: "version",
    textField: "software",
    timeField: "@timestamp"
  };

//
// End dashboard annotations
//

//
// Begin define transformations
//
local myTransformations = {
  groupByModelSortByTimestamp()::
    {
      transformations: [
        {
          id: "groupingToMatrix",
          options: {
            columnField: "model_name",
            rowField: "@timestamp",
            valueField: "value",
            emptyValue: "null"
          }
        },
        {
          id: "convertFieldType",
          options: {
            fields: {},
            conversions: [
              {
                targetField: "@timestamp\\model_name",
                destinationType: "time"
              }
            ]
          }
        },
      ]
    },
  groupByConcurrencyAndSort()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "virtual_users"
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
                targetField: "virtual_users",
                destinationType: "string"
              }
            ]
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "model_name",
            rowField: "virtual_users",
            valueField: "value",
            emptyValue: "null"
          }
        },
      ]
    },
  groupByModelAndConcurrency()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "virtual_users"
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
                targetField: "virtual_users",
                destinationType: "string"
              }
            ]
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "virtual_users",
            rowField: "model_name",
            valueField: "value",
            emptyValue: "null"
          }
        },
        {
          "id": "renameByRegex",
          "options": {
            "regex": "(.*)",
            "renamePattern": "$1 virtual users"
          }
        }
      ]
    },
  groupByModelAndSort()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "model_name"
              }
            ]
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "model_name",
            rowField: "model_name",
            valueField: "value",
            emptyValue: "null"
          }
        },
      ]
    },
  groupByRhoai()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "model_name"
              }
            ]
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "rhoai_version",
            rowField: "model_name",
            valueField: "value",
            emptyValue: "null"
          }
        },
      ]
    },
  groupByModelAndRhoai()::
    {
      transformations: [
        {
          id: "sortBy",
          options: {
            fields: {},
            sort: [
              {
                field: "model_name"
              }
            ]
          }
        },
        {
          id: "groupBy",
          options: {
            fields: {
              value: {
                aggregations: [
                  "mean"
                ],
                operation: "aggregate"
              },
              accelerator_name: {
                aggregations: [],
                operation: null
              },
              model_name: {
                aggregations: [],
                operation: "groupby"
              },
              rhoai_version: {
                aggregations: [],
                operation: "groupby"
              }
            }
          }
        },
        {
          id: "groupingToMatrix",
          options: {
            columnField: "rhoai_version",
            rowField: "model_name",
            valueField: "value (mean)",
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
          options: "virtual_users\\model_name"
        },
        properties: [
          {
            id: "custom.axisLabel",
            value: "Virtual users"
          }
        ]
      },
      {
        matcher: {
          id: "byName",
          options: "virtual_users\\model_name"
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
        id=null,
        description='',
        targets=[],
        transparent=false,
        unit=null,
        min=null,
        max=null,
        axisLabel='',
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
        + g.panel.timeSeries.fieldConfig.defaults.custom.withAxisLabel(axisLabel)
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
        legendCalcs=[],
        stacking=null,
        tooltipMode='single',
        fillOpacity=6,
        gradientMode='opacity',
        axisWidth=null,
        withXTickLabelMaxLength=null,
        withXTickLabelRotation=0,
        withXTickLabelSpacing=0,
        thresholdMode=null,
        thresholdSteps=[],
        transformations={},
        overrides=[],
    ):: g.panel.barChart.new(title)
        + transformations
        + g.panel.barChart.panelOptions.withDescription(description)
        + g.panel.barChart.queryOptions.withTargets(targets)
        + (if transparent then g.panel.barChart.panelOptions.withTransparent() else {})
        + g.panel.barChart.standardOptions.withUnit(unit)
        + g.panel.barChart.standardOptions.withMin(min)
        + g.panel.barChart.standardOptions.withMax(max)
        + g.panel.barChart.standardOptions.withDecimals(decimals)
        + (if stacking != null then g.panel.barChart.options.withStacking(stacking) else {})        
        + g.panel.barChart.options.withXTickLabelMaxLength(withXTickLabelMaxLength)
        + g.panel.barChart.options.withXTickLabelRotation(withXTickLabelRotation)
        + g.panel.barChart.options.withXTickLabelSpacing(withXTickLabelSpacing)
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
    unit='ms',
    decimals=4,
    legendPlacement='left',
    fillOpacity=60,
    transformations = myTransformations.groupByModelSortByTimestamp()
  ),
};

local timese ={
  kserve_llm_load_test_throughput:: panelo.timeSeries(
    title='Kserve LLM load test throughput over time',
    description='Output Tokens per Second; Higher is better',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_throughput(),
    ],
    id='Kserve LLM load test throughput over time',
    min=0,
    axisLabel='Throughput',
    unit='',
    decimals=0,
    legendPlacement='bottom',
    stackingMode='normal',
    fillOpacity=60,
    drawStyle='line',
    gradientMode=null,
    transformations = myTransformations.groupByModelSortByTimestamp()
  ),
};

local bchart ={
  kserve_llm_load_test_tpot_rhoai:: panelo.barChart(
    title='Kserve LLM load test TPOT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_tpot_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    withXTickLabelMaxLength=20,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByRhoai(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_ttft_rhoai:: panelo.barChart(
    title='Kserve LLM load test TTFT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_ttft_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    withXTickLabelMaxLength=20,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByRhoai(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_model_load_duration_rhoai:: panelo.barChart(
    title='Kserve LLM model load duration',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_model_load_duration(),
    ],
    min=0,
    axisLabel='Time',
    unit='s',
    decimals=2,
    legendPlacement='bottom',
    withXTickLabelMaxLength=20,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByRhoai(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_throughput_rhoai:: panelo.barChart(
    title='Kserve LLM load test throughput',
    description='Output Tokens per Second; Higher is better',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_throughput(),
    ],
    min=0,
    axisLabel='Throughput',
    unit='',
    decimals=0,
    legendPlacement='bottom',
    withXTickLabelMaxLength=20,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByRhoai(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_failures_rhoai:: panelo.barChart(
    title='Kserve LLM load test failures (mean)',
    description='Failures',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_failures(),
    ],
    min=0,
    axisLabel='Errors',
    unit='',
    decimals=0,
    legendPlacement='bottom',
    withXTickLabelMaxLength=20,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    transformations = myTransformations.groupByModelAndRhoai(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),

  kserve_llm_load_test_tpot_m:: panelo.barChart(
    title='Kserve LLM load test TPOT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_tpot_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    stacking='normal',
    legendPlacement='bottom',
    withXTickLabelMaxLength=8,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendMode='list',
    transformations = myTransformations.groupByModelAndSort(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_ttft_m:: panelo.barChart(
    title='Kserve LLM load test TTFT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_ttft_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    stacking='normal',
    legendPlacement='bottom',
    withXTickLabelMaxLength=8,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendMode='list',
    transformations = myTransformations.groupByModelAndSort(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_model_load_duration_m:: panelo.barChart(
    title='Kserve LLM model load duration',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_model_load_duration(),
    ],
    min=0,
    axisLabel='Time',
    unit='s',
    decimals=2,
    stacking='normal',
    legendPlacement='bottom',
    withXTickLabelMaxLength=8,
    withXTickLabelRotation=-45,
    fillOpacity=60,
    gradientMode=null,
    legendMode='list',
    transformations = myTransformations.groupByModelAndSort(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_throughput_m:: panelo.barChart(
    title='Kserve LLM load test throughput',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_throughput(),
    ],
    min=0,
    axisLabel='Throughput',
    unit='',
    decimals=0,
    withXTickLabelMaxLength=15,
    withXTickLabelRotation=-45,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByModelAndConcurrency(),
    //overrides = myOverrides.AxisAndModel().overrides
  ),

  kserve_llm_load_test_tpot:: panelo.barChart(
    title='Kserve LLM load test TPOT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_tpot_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByConcurrencyAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_ttft:: panelo.barChart(
    title='Kserve LLM load test TTFT (min)',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_ttft_min(),
    ],
    min=0,
    axisLabel='Time',
    unit='ms',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByConcurrencyAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_model_load_duration:: panelo.barChart(
    title='Kserve LLM model load duration',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_model_load_duration(),
    ],
    min=0,
    axisLabel='Time',
    unit='s',
    decimals=2,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByConcurrencyAndSort(),
    overrides = myOverrides.AxisAndModel().overrides
  ),
  kserve_llm_load_test_throughput:: panelo.barChart(
    title='Kserve LLM load test throughput',
    targets=[
      opensearch_queries.get_kserve_llm_load_test_throughput(),
    ],
    min=0,
    axisLabel='Throughput',
    unit='',
    decimals=0,
    legendPlacement='bottom',
    fillOpacity=60,
    gradientMode=null,
    legendCalcs=['max', 'min', 'mean', 'variance'],
    transformations = myTransformations.groupByConcurrencyAndSort(),
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
local w = g.panel.barChart.gridPos.withW;
local h = g.panel.barChart.gridPos.withH;
local x = g.panel.barChart.gridPos.withX;
local y = g.panel.barChart.gridPos.withY;

g.dashboard.new('Watsonx Kserve LLM load tests')
+ g.dashboard.withDescription('Load test results for Kserve LLM (remote OS instance)')
+ g.dashboard.withRefresh('1m')
+ g.dashboard.withUid('watsonx-rhoai-kserve-dashboard')
// This just stopped to work...
// + g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withVariables([
  model_nameVar,
  virtual_usersVar,
  rhoai_versionVar,
  ocp_versionVar,
  accelerator_nameVar,
])
+ g.dashboard.withAnnotations([
  rhods_annotation,
  ocp_annotation,
])
+ g.dashboard.withPanels(
[
  g.panel.row.new("LLM Load tests by model") + x(0) + y(0),
  myPanels.barChart.kserve_llm_load_test_tpot_m + x(0) + y(1) + w(8) + h(11),
  myPanels.barChart.kserve_llm_load_test_ttft_m + x(8) + y(1) + w(8) + h(11),
  myPanels.barChart.kserve_llm_load_test_model_load_duration_m + x(16) + y(1) + w(8) + h(11),
  myPanels.barChart.kserve_llm_load_test_throughput_m + x(0) + y(12) + w(24) + h(11),
  g.panel.row.new("LLM Load tests by virtual_users") + x(0) + y(13),
  myPanels.barChart.kserve_llm_load_test_tpot + x(0) + y(27)  + w(24) + h(14),
  myPanels.barChart.kserve_llm_load_test_ttft + x(0) + y(41)  + w(24) + h(14),
  // myPanels.barChart.kserve_llm_load_test_model_load_duration + x(0) + y(27)  + w(12) + h(14),
  myPanels.barChart.kserve_llm_load_test_throughput + x(0) + y(55)  + w(69) + h(14),
  g.panel.row.new("LLM Load tests by OpenShift AI version") + x(0) + y(83),
  myPanels.barChart.kserve_llm_load_test_tpot_rhoai + x(0) + y(84)  + w(12) + h(14),
  myPanels.barChart.kserve_llm_load_test_ttft_rhoai + x(12) + y(84)  + w(12) + h(14),
  myPanels.barChart.kserve_llm_load_test_model_load_duration_rhoai + x(0) + y(98)  + w(12) + h(14),
  myPanels.barChart.kserve_llm_load_test_throughput_rhoai + x(12) + y(98)  + w(12) + h(14),
  myPanels.barChart.kserve_llm_load_test_failures_rhoai + x(0) + y(112)  + w(24) + h(14),
  g.panel.row.new("LLM Load tests over time") + x(0) + y(126),
  myPanels.timeSeries.kserve_llm_load_test_throughput + x(0) + y(127)  + w(24) + h(14),
])

//
// End dashboard definition
//
