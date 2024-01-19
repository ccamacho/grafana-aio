# dashboard.jsonnet
// https://github.com/kondratyevd/purdue-af/blob/master/monitoring/dashboards/panels/timeSeries.jsonnet
// https://github.com/kondratyevd/purdue-af/blob/master/monitoring/dashboards/public/purdue-af.jsonnet

local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local influ = {
    addQuery(
        format=null
    ):: 

        g.panel.timeSeries.queryOptions.withDatasource('get_data_frominflux', 'influxdb-local')
        + {
          query: 'SELECT value FROM autogen.cpu_idle WHERE value::field > 1 GROUP BY hostName::tag ORDER BY time ASC',
          rawQuery: true,
          alias: 'Frequency',
          groupBy: [
            {
              params: [
                '$__interval',
              ],
              type: 'time',
            },
            {
              params: [
                'none',
              ],
              type: 'fill',
            },
          ],
          measurement: 'telemetry_v2',
          orderByTime: 'ASC',
          policy: 'default',
          refId: 'A',
          resultFormat: 'time_series',
          select: [
            [
              {
                params: [
                  'system_frequency_freq_hz',
                ],
                type: 'field',
              },
              {
                params: [],
                type: 'mean',
              },
            ],
          ],
          tags: [
            {
              key: 'device_id',
              operator: '=~',
              value: '/^$device$/',
            },
          ],
        },
};

local promethe = {
    addQuery(
        datasource,
        query,
        refId='',
        format=null,
        legendFormat='',
        instant=false
    ):: 
        g.query.prometheus.new(datasource, query)
        + g.query.prometheus.withRefId(refId)
        + g.query.prometheus.withFormat(format)
        + g.query.prometheus.withLegendFormat(legendFormat)
        + (if instant then g.query.prometheus.withInstant() else {})
};



local rowpanel = {
    af_metrics:: g.panel.row.new('Purdue Analysis Facility metrics'),
    gpu_metrics:: g.panel.row.new('GPU metrics'),
    triton_metrics:: g.panel.row.new('Triton metrics'),
    dask_metrics:: g.panel.row.new('Dask metrics'),
    slurm_metrics:: g.panel.row.new('Slurm metrics'),
    hub_metrics:: g.panel.row.new('JupyterHub diagnostocs'),
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
        legendPlacement=null,
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
    title='Grafonnet and InfluxDB',
    targets=[
      influ.addQuery(),
    ],
    min=0,
    decimals=0,
    legendPlacement='right',
    stackingMode='normal',
    fillOpacity=60,
    gradientMode=null
  ),



  serverStartTimes:: panelo.timeSeries(
    title='User pod start times',
    targets=[
      influ.addQuery(),
    ],
    unit='s',
    min=0,
    legendMode='hidden',
    drawStyle='points',
    thresholdMode='area',
    thresholdSteps=[
      { color: 'green', value: 30 },
      { color: 'yellow', value: 40 },
      { color: 'orange', value: 75 },
      { color: 'red', value: 120 },
    ]
  ),
};

local thetable = {

      gpuSlices:: g.panel.table.new('')
      + g.panel.table.queryOptions.withTargets([
        g.query.prometheus.new(
          'influxdb',
          'SELECT value FROM autogen.cpu_idle WHERE value::field > 1 GROUP BY hostName::tag ORDER BY time ASC)',
        )
        + g.query.prometheus.withLegendFormat('{{modelName}} {{GPU_I_PROFILE}}')
        + g.query.prometheus.withInstant()
        + g.query.prometheus.withFormat('table')       
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.transformation.withId('organize')
        + g.panel.table.transformation.withOptions(
          {
            "excludeByName": {"Time": true},
            "indexByName": {
                "modelName": 0,
                "GPU_I_PROFILE": 1,
                "Value": 2,
            },
          }
        ),
      ])
      + g.panel.table.queryOptions.withTransformations([
        g.panel.table.transformation.withId('sortBy')
        + g.panel.table.transformation.withOptions({"sort": [{"field": "GPU_I_PROFILE"}]})
      ])
      + g.panel.table.standardOptions.withOverrides(
        [
          g.panel.table.fieldOverride.byName.new("modelName")
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withDisplayName("Model")
          ),
          g.panel.table.fieldOverride.byName.new("GPU_I_PROFILE")
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withDisplayName("Partition")
          ),
          g.panel.table.fieldOverride.byName.new("Value")
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withDisplayName("# instances")
          ),
          g.panel.table.fieldOverride.byRegexp.new("/.*/")
          + g.panel.table.fieldOverride.byRegexp.withProperty("custom.align", "left")
        ]
      ),
        tritonTable:: g.panel.table.new(''),
    };

local myPanels = {
  row: rowpanel,
  timeSeries: timese,
//  stat: import 'stat.jsonnet',
  table: thetable,
//  gauge: import 'gauge.jsonnet',
//  barGauge: import 'barGauge.jsonnet',
//  heatmap: import 'heatmap.jsonnet',
//  placeholder: import 'placeholder.jsonnet'
};

local w = g.panel.timeSeries.gridPos.withW;
local h = g.panel.timeSeries.gridPos.withH;

g.dashboard.new('Grafonnet and InfluxDB example')
+ g.dashboard.withUid('purdue-af-dashboard')
+ g.dashboard.withDescription('Purdue Analysis Facility monitoring')
+ g.dashboard.withRefresh('1m')
// This just stopped to work...
// + g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withPanels([
  //myPanels.row.af_metrics               + w(24) + h(2),
  myPanels.timeSeries.usersPerNamespace + w(10) + h(8),
  //myPanels.table.gpuSlices              + w(7)  + h(10),
  myPanels.timeSeries.serverStartTimes  + w(8) + h(10),

])
