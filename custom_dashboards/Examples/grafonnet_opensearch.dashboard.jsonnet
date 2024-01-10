local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

local opense = {
    addQuery(
        format=null
    ):: 
        g.panel.timeSeries.queryOptions.withDatasource('get_data_from_opensearch', 'opensearch-local')
        + {
          query: '*',
          alias: 'AliasExample',
          queryType: "lucene",
          metrics: [
            {
              id: "1",
              type: "avg",
              field: "cpu_idle_percentage"
            }
          ],
          format: "table",
          timeField: "@timestamp",
          luceneQueryType: "Metric",
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
    title='Grafonnet and OpenSearch',
    targets=[
      opense.addQuery(),
    ],
    min=0,
    decimals=0,
    legendPlacement='right',
    stackingMode='normal',
    fillOpacity=60,
    gradientMode=null
  ),
};

local myPanels = {
  // row: rowpanel,
  timeSeries: timese,
};

local w = g.panel.timeSeries.gridPos.withW;
local h = g.panel.timeSeries.gridPos.withH;

g.dashboard.new('Grafonnet and OpenSearch example')
+ g.dashboard.withUid('grafonnet-opensearch')
+ g.dashboard.withDescription('Simple Grafonnet and OpenSearch example')
+ g.dashboard.withRefresh('1m')
+ g.dashboard.withStyle(value="dark")
+ g.dashboard.withTimezone(value="browser")
+ g.dashboard.time.withFrom(value="now-6h")
+ g.dashboard.time.withTo(value="now")
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.withPanels([
  myPanels.timeSeries.usersPerNamespace + w(10) + h(8),
])
