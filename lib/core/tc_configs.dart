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

  /// [blockHeight] defines how tall 60 minutes should be.
  /// For example, [x150] means that 90px will be used for a 60 minute block.
  /// To calculate the height, H, of an event D minutes long, use:
  ///   H = (D / 60) * [blockHeight]
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
  final TCSynchroniser synchroniser;

  TCConfigs({
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
  })  : timeMarkerColor = timeMarkerColor ?? secondaryColor,
        synchroniser = TCSynchroniser(
          events: [for (TCCalendar cal in calendars) ...cal.events],
        );
}

class TCCalendar {
  final TCSemanticColor primaryColor;
  final TCSemanticColor accentColor;
  final List<TCEvent> events = [];

  TCCalendar({
    required this.primaryColor,
    required this.accentColor,
  });
}

class TCSemanticColor {
  final Color color;

  const TCSemanticColor({
    required this.color,
  });
}

class TCSynchroniser {
  final Map<String, TCEvent> repository;

  TCSynchroniser({
    required List<TCEvent> events,
  }) : repository = {for (TCEvent event in events) event.uid: event};

  void update(TCEvent newData) => repository[newData.uid] = newData;
}
