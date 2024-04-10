library turbocal;

import 'package:flutter/material.dart';
part './cal_objects.dart';
part './configs.dart';
part './utils.dart';

typedef TCWidgetBuilder<T> = Widget Function(T data, BuildContext cx);

class TCInstance extends StatefulWidget {
  final List<TCEvent> events;
  final TCConfigs configs;

  const TCInstance({
    required this.events,
    required this.configs,
    super.key,
  });

  @override
  State<TCInstance> createState() => TCInstanceState();
}

class TCInstanceState extends State<TCInstance> {
  late final int columnCount;
  late final double blockWidth;
  late final double blockHeight;
  late DateTime mainViewDateScopeStart;
  late DateTime mainViewDateScopeEnd;
  final List<TCEvent> eventsInView = [];
  final ScrollController mainViewScrollController = ScrollController();
  bool scrollIsZero = true;

  @override
  void initState() {
    mainViewScrollController.addListener(() {
      if (mainViewScrollController.offset == 0) {
        setState(() {
          scrollIsZero = true;
        });
      } else {
        if (scrollIsZero) {
          setState(() {
            scrollIsZero = false;
          });
        }
      }
    });
    computeInstanceView();
    computeMainView();
    super.initState();
  }

  void computeInstanceView() {
    columnCount = widget.configs.instanceView.columnCount;
    blockWidth =
        (widget.configs.windowWidth - timeMarkerColumnWidth) / columnCount;
    blockHeight = widget.configs.timescaleZoom.blockHeight;
  }

  void computeMainView() {
    final DateTime dtNow = now();
    final DateTime nowDay = DateTime(dtNow.year, dtNow.month, dtNow.day);
    mainViewDateScopeStart = widget.configs.mainViewDateScopeStart ??
        nowDay.subtract(Duration(days: dtNow.weekday - 1));
    mainViewDateScopeEnd = mainViewDateScopeStart
        .add(Duration(days: widget.configs.instanceView.dayCount));
    eventsInView
      ..clear()
      ..addAll(cleanUpEventData(widget.events));
  }

  Iterable<TCEvent> cleanUpEventData(List<TCEvent> events) {
    return events.where((e) =>
        e.dtStart.isAfter(mainViewDateScopeStart) &&
        e.dtEnd.isBefore(mainViewDateScopeEnd));
  }

  List<TCColumn> buildTCColumnsForWeek() {
    final List<TCColumn> cols = [];
    for (int i = 0; i < columnCount; i++) {
      final DateTime colDateStart =
          mainViewDateScopeStart.add(Duration(days: i));
      cols.add(
        TCColumn(
          dayStamp: colDateStart,
          configs: widget.configs,
          blockWidth: blockWidth,
          blockHeight: blockHeight,
          events: eventsInView
              .where((e) =>
                  e.dtStart.isAfter(colDateStart) &&
                  e.dtEnd.isBefore(colDateStart.add(
                    const Duration(hours: 24),
                  )))
              .toList(),
        ),
      );
    }
    return cols;
  }

  Widget buildTimeMarkers() {
    final List<Widget> timeMarkers = [];
    for (int i = 0; i < 24; i++) {
      timeMarkers.add(
        SizedBox(
          width: timeMarkerColumnWidth,
          height: widget.configs.timescaleZoom.blockHeight,
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                '${i.toDoubleDigitZeroPadded()}:00',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox(
      width: timeMarkerColumnWidth,
      height: widget.configs.timescaleZoom.blockHeight * 24,
      child: Column(children: timeMarkers),
    );
  }

  List<Widget> buildWeekDayLabels() {
    return [
      for (final d in dayLabels)
        SizedBox(
          width: blockWidth,
          height: weekDayLabelsRowHeight,
          child: Center(
            child: Text(d),
          ),
        ),
    ];
  }

  Widget buildMainViewForWeek() {
    return Stack(
      children: [
        Positioned(
          top: weekDayLabelsRowHeight + panelHeight,
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight -
              (weekDayLabelsRowHeight + panelHeight),
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: mainViewScrollController,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    buildTimeMarkers(),
                    ...buildTCColumnsForWeek(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: panelHeight,
          height: weekDayLabelsRowHeight,
          width: widget.configs.windowWidth,
          child: Container(
            clipBehavior: Clip.none,
            decoration: scrollIsZero
                ? null
                : BoxDecoration(
                    color: widget.configs.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        offset: const Offset(0, 10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
            child: Row(children: [
              const SizedBox(width: timeMarkerColumnWidth),
              ...buildWeekDayLabels()
            ]),
          ),
        ),
        Positioned(
          width: widget.configs.windowWidth,
          height: panelHeight,
          child: Container(
            width: widget.configs.windowWidth,
            height: panelHeight,
            color: widget.configs.panelColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: Container(
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight,
          color: widget.configs.primaryColor,
          child: widget.configs.instanceView == TCInstanceView.week
              ? buildMainViewForWeek()
              : const SizedBox(),
        ),
      ),
    );
  }
}

class TCColumn extends StatefulWidget {
  final double blockWidth;
  final double blockHeight;
  final List<TCEvent> events;
  final TCConfigs configs;
  final DateTime dayStamp;

  const TCColumn({
    required this.configs,
    required this.blockWidth,
    required this.blockHeight,
    required this.events,
    required this.dayStamp,
    super.key,
  });

  @override
  State<TCColumn> createState() => TCColumnState();
}

class TCColumnState extends State<TCColumn> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> timeMarkerBlocks = [];
    for (int i = 0; i < 24; i++) {
      timeMarkerBlocks.add(
        Center(
          child: Container(
            width: widget.blockWidth,
            height: widget.configs.timescaleZoom.blockHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.configs.secondaryColor,
                width: 0.1,
              ),
              color: widget.configs.primaryColor,
            ),
          ),
        ),
      );
    }
    return SizedBox(
      /// This stack contains the time marker grid and event canvas
      child: Stack(
        children: [
          Column(children: timeMarkerBlocks),
          TCEventCanvas(
            dayStamp: widget.dayStamp,
            events: widget.events,
            configs: widget.configs,
            maxWidth: widget.blockWidth - defaultFixedEventCanvasIndent,
          ),
        ],
      ),
    );
  }
}

class TCEventCanvas extends StatefulWidget {
  final DateTime dayStamp;
  final double maxWidth;
  final TCConfigs configs;
  final List<TCEvent> events;

  const TCEventCanvas({
    required this.maxWidth,
    required this.configs,
    required this.events,
    required this.dayStamp,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TCEventCanvasState();
}

class TCEventCanvasState extends State<TCEventCanvas> {
  final List<TCEvent> sortedEvents = [];

  void init() {
    if (widget.events.isEmpty) return;
    if (widget.events.length == 1) {
      sortedEvents.add(widget.events[0]);
    } else {
      sortedEvents
        ..addAll(widget.events)
        ..sort((a, b) => b.dtStart.compareTo(a.dtStart));
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void resetState() {
    sortedEvents.clear();
  }

  List<List<TCRenderData>> resolveCollisions() {
    final List<List<TCRenderData>> layers = [];
    int layer = 0;
    DateTime prevDt;
    while (sortedEvents.isNotEmpty) {
      final TCEvent ev = sortedEvents.first;
      layers.add([
        TCRenderData(
          width: widget.maxWidth,
          height: widget.configs.timescaleZoom
              .minutesToHeight(ev.durationSpan.inMinutes),
          offset: widget.configs.timescaleZoom.minutesToHeight(
            ev.dtStart.difference(widget.dayStamp).inMinutes,
          ),
          event: ev,
        )
      ]);

      prevDt = ev.dtStart;
      sortedEvents.removeAt(0);
      if (sortedEvents.isNotEmpty) {
        for (int i = 0; i < sortedEvents.length; i++) {
          final TCEvent ev = sortedEvents[i];
          if (!ev.dtStart.isAfter(
              prevDt.add(widget.configs.timescaleZoom.heightToMinutes(20)))) {
            continue;
          } else {
            layers[layer].add(
              TCRenderData(
                width: widget.maxWidth - (indentSize * layer),
                event: ev,
                height: widget.configs.timescaleZoom
                    .minutesToHeight(ev.durationSpan.inMinutes),
                offset: widget.configs.timescaleZoom.minutesToHeight(
                  ev.dtStart.difference(widget.dayStamp).inMinutes,
                ),
              ),
            );
          }
        }
        layer += 1;
      } else {
        return layers;
      }
    }
    return layers;
  }

  List<TCRenderData> flattenLayers(List<List<TCRenderData>> layers) {
    final List<TCRenderData> flattened = [];
    for (int i = 0; i < layers.length; i++) {
      for (int j = 0; j < layers[i].length; j++) {
        flattened.add(layers[i][j]);
      }
    }
    return flattened;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: widget.configs.timescaleZoom.blockHeight * 24,
      child: Stack(
        children: [
          for (final e in flattenLayers(resolveCollisions()))
            Positioned(
              top: e.offset,
              right: 0,
              width: e.width,
              height: e.height,
              child: Container(
                width: e.width,
                height: e.height,
                color: Colors.red,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(e.event.summary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TCRenderData {
  final TCEvent event;
  final double width;
  final double height;
  final double offset;

  const TCRenderData({
    required this.width,
    required this.height,
    required this.offset,
    required this.event,
  });
}



/* class CollisionGroup {
  final List<TCEvent> events = [];
  DateTime start;
  DateTime end;

  CollisionGroup({
    required this.start,
    required this.end,
  });

  void addEvent(TCEvent event) {

  }
} */
