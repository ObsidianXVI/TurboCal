part of turbocal;

class TCConfigs {
  final TCInstanceView instanceView;
  final TCTimescaleZoom timescaleZoom;
  final Color secondaryColor;
  final Color primaryColor;
  final Color metaColor;
  final Color panelColor;
  final double windowWidth;
  final double windowHeight;
  final DateTime? mainViewDateScopeStart;

  final TCWidgetBuilder<String>? eventTitleBuilder;
  final TCWidgetBuilder<String>? timeMarkerBuilder;

  final bool scrollToCurrentTime;

  TCConfigs({
    required this.instanceView,
    required this.timescaleZoom,
    required this.primaryColor,
    required this.secondaryColor,
    required this.panelColor,
    required this.metaColor,
    required this.windowHeight,
    required this.windowWidth,
    this.mainViewDateScopeStart,
    this.eventTitleBuilder,
    this.timeMarkerBuilder,
    this.scrollToCurrentTime = false,
  });
}

enum TCInstanceView {
  // day,

  // fourDay,
  week(7, 7);
  // month,
  // schedule,

  final int columnCount;
  final int dayCount;

  const TCInstanceView(this.columnCount, this.dayCount);
}

enum TCTimescaleZoom {
  x25(18),
  x50(36),
  x75(48),
  x100(60),
  x125(72),
  x150(90),
  x200(120);

  /// [blockHeight] defines how tall 60 minutes should be.
  /// For example, [x150] means that 90px will be used for a 60 minute block.
  /// To calculate the height, H, of an event D minutes long, use:
  ///   H = (D / 60) * [blockHeight]
  final double blockHeight;

  const TCTimescaleZoom(this.blockHeight);
}
