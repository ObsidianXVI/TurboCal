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
    buildInstanceView();
    buildMainView();
    super.initState();
  }

  void buildInstanceView() {
    columnCount = widget.configs.instanceView.columnCount;
    blockWidth = widget.configs.windowWidth / columnCount;
    blockHeight = widget.configs.timescaleZoom.blockHeight;
  }

  void buildMainView() {
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

  List<Widget> buildTimeMarkers() {
    final List<Widget> timeMarkers = [];

    return timeMarkers;
  }

  List<Widget> buildWeekDayLabels() {
    return [
      for (final d in dayLabels)
        SizedBox(
          width: blockWidth,
          height: 40,
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
          top: 120,
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: mainViewScrollController,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(children: buildTCColumnsForWeek()),
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          height: 40,
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
            child: Row(children: buildWeekDayLabels()),
          ),
        ),
        Positioned(
          width: widget.configs.windowWidth,
          height: 80,
          child: Container(
            width: widget.configs.windowWidth,
            height: 80,
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

  const TCColumn({
    required this.configs,
    required this.blockWidth,
    required this.blockHeight,
    required this.events,
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
          TCEventCanvas(),
        ],
      ),
    );
  }
}

class TCEventCanvas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
