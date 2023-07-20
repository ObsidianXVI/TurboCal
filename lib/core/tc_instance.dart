part of turbocal;

//DateTime.now().hour - 1
class TCInstance extends StatefulWidget {
  final TCConfigs configs;
  final List<TCCalendar> calendars;
  final List<TCEvent> events = [];
  late DateTime dateNow = DateTime.now();
  DateTime scopeStartDate = DateTime.now();
  int dayOfWeek = 0;

  TCInstance({
    required this.configs,
    required this.calendars,
    super.key,
  }) {
    for (TCCalendar cal in calendars) {
      events.addAll(cal.events);
    }
    dayOfWeek = dateNow.weekday;
    scopeStartDate = DateTime.utc(dateNow.year, dateNow.month, dateNow.day)
        .subtract(Duration(days: dayOfWeek - 1));
  }

  @override
  State<TCInstance> createState() => _TCTInstanceState();
}

class _TCTInstanceState extends State<TCInstance> {
  final ScrollController scrollController = ScrollController();

  void scrollCanvasToDefault() {
    final double defaultOffset;
    if (widget.configs.defaultBlockNum != null) {
      defaultOffset = widget.configs.defaultBlockNum! *
          widget.configs.timescaleZoom.blockHeight;
    } else {
      if (widget.configs.scrollToCurrentTime) {
        defaultOffset = (DateTime.now().hour - 1) *
            widget.configs.timescaleZoom.blockHeight;
      } else {
        defaultOffset = 0;
      }
    }
    scrollController.jumpTo(defaultOffset);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, scrollCanvasToDefault);
  }

  @override
  Widget build(BuildContext context) {
    // List of the columns to be displayed in the main view
    final List<Widget> columns = List<Widget>.generate(
      widget.configs.instanceView.columnCount,
      (int index) {
        final DateTime colDateStart =
            widget.scopeStartDate.add(Duration(days: index));
        final DateTime colDateEnd = colDateStart.add(const Duration(hours: 24));
        final Iterable<TCEvent> events = widget.events.where((TCEvent e) =>
            e.dtStart.isAfter(colDateStart) && e.dtEnd.isBefore(colDateEnd));
        return TCColumn(
          configs: widget.configs,
          dateInfo: colDateStart,
          eventsData: events,
        );
      },
    );

    return Material(
      child: Center(
        child: Container(
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight,
          color: widget.configs.primaryColor,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: NotificationListener<ScopeStartDateChangeNotification>(
              onNotification: (notification) {
                setState(() {
                  widget.scopeStartDate = notification.newScopeStartDate;
                });
                return true;
              },
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 0,
                    width: widget.configs.windowWidth,
                    height: widget.configs.windowHeight - 80,
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Row(
                        children: [
                          TCTimeMarkerColumn(
                            configs: widget.configs,
                          ),
                          const SizedBox(width: 5),
                          ...columns,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    height: 80,
                    width: widget.configs.windowWidth,
                    child: TCPanel(
                      tcInstance: widget,
                      configs: widget.configs,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
