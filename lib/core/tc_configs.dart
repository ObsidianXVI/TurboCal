part of turbocal;

enum TCEventStatus { confirmed }

enum TCEventTransp { opaque }

enum TCInstanceView {
  // day,
  // fourDay,
  week(7);
  // month,
  // schedule,

  final int columnCount;

  const TCInstanceView(this.columnCount);
}

enum TCTimescaleZoom {
  x25(18),
  x50(36),
  x75(48),
  x100(60),
  x125(72),
  x150(90),
  x200(120);

  final double blockHeight;

  const TCTimescaleZoom(this.blockHeight);
}

class TCConfigs {
  final List<TCCalendar> calendars;
  final TCInstanceView instanceView;
  final TCTimescaleZoom timescaleZoom;
  final Color secondaryColor;
  final Color primaryColor;
  final Color metaColor;
  final Color panelColor;
  final double windowWidth;
  final double windowHeight;
  final double fontSize;
  final String? fontFamily;
  final Color timeMarkerColor;
  final int? defaultBlockNum;
  final bool scrollToCurrentTime;

  const TCConfigs({
    required this.calendars,
    required this.instanceView,
    required this.timescaleZoom,
    required this.primaryColor,
    required this.secondaryColor,
    required this.panelColor,
    required this.metaColor,
    required this.windowHeight,
    required this.windowWidth,
    this.defaultBlockNum,
    this.scrollToCurrentTime = false,
    this.fontSize = 11,
    this.fontFamily,
    Color? timeMarkerColor,
  }) : timeMarkerColor = timeMarkerColor ?? secondaryColor;
}

class TCCalendar {
  final TCSemanticColor semanticColor;
  final List<TCEvent> events = [];

  TCCalendar({
    required this.semanticColor,
  });
}

class TCSemanticColor {
  final Color color;

  const TCSemanticColor({
    required this.color,
  });
}
