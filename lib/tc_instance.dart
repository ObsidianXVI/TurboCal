part of turbocal;

final GlobalKey instanceKey = GlobalKey<TCInstanceState>();

class TCInstance extends StatefulWidget {
  final Map<String, TCEvent> eventsRegistry = {};
  final TCConfigs configs;

  TCInstance({
    required List<TCEvent> events,
    required this.configs,
  }) : super(key: instanceKey) {
    eventsRegistry.addAll({for (final e in events) e.uid: e});
  }

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

  /// Sets the [columnCount], [blockWidth], [blockHeight] for the instance
  void computeInstanceView() {
    columnCount = widget.configs.instanceView.columnCount;
    blockWidth =
        (widget.configs.windowWidth - timeMarkerColumnWidth) / columnCount;
    blockHeight = widget.configs.timescaleZoom.blockHeight;
  }

  /// Computes the [mainViewDateScopeStart] and [mainViewDateScopeEnd]
  void computeMainView() {
    final DateTime dtNow = now();
    final DateTime nowDay = DateTime(dtNow.year, dtNow.month, dtNow.day);
    mainViewDateScopeStart = widget.configs.mainViewDateScopeStart ??
        nowDay.subtract(Duration(days: dtNow.weekday - 1));
    mainViewDateScopeEnd = mainViewDateScopeStart
        .add(Duration(days: widget.configs.instanceView.dayCount));
  }

  /// Fetches events within the range of [mainViewDateScopeStart] and [mainViewDateScopeEnd]
  Iterable<TCEvent> cleanUpEventData(List<TCEvent> events) {
    return eventsInView
      ..clear()
      ..addAll(
        events.where((e) =>
            e.dtStart.isAfter(mainViewDateScopeStart) &&
            e.dtEnd.isBefore(mainViewDateScopeEnd)),
      );
  }

  /// Builds the [TCColumn]s for the week view
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

  /// Builds the time marker column
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
    final List<Widget> labels = [];
    for (int i = 0; i < dayLabels.length; i++) {
      final DateTime dayDT = mainViewDateScopeStart.add(Duration(days: i));
      labels.add(
        SizedBox(
          width: blockWidth,
          height: weekDayLabelsRowHeight,
          child: Center(
            child: Text(
                "${dayLabels[i]}, ${dayDT.day} ${MonthLabels.values[dayDT.month - 1].shortName}"),
          ),
        ),
      );
    }
    return labels;
  }

  Widget buildMainViewForWeek() {
    cleanUpEventData(widget.eventsRegistry.values.toList());
    return Stack(
      children: [
        // MainView
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

        // DayLabels
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

        // Panel
        Positioned(
          width: widget.configs.windowWidth,
          height: panelHeight,
          child: Container(
            width: widget.configs.windowWidth,
            height: panelHeight,
            color: widget.configs.panelColor,
            child: Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        mainViewDateScopeStart = mainViewDateScopeStart
                            .subtract(const Duration(days: 7));
                        mainViewDateScopeEnd = mainViewDateScopeEnd
                            .subtract(const Duration(days: 7));
                      });
                    },
                    style: const ButtonStyle(
                      iconColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        mainViewDateScopeStart =
                            mainViewDateScopeStart.add(const Duration(days: 7));
                        mainViewDateScopeEnd =
                            mainViewDateScopeEnd.add(const Duration(days: 7));
                      });
                    },
                    style: const ButtonStyle(
                      iconColor: MaterialStatePropertyAll(Colors.white),
                    ),
                    child: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
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
