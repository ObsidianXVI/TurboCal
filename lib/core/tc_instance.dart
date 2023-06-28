part of turbocal;

class TCInstance extends StatefulWidget {
  final GlobalKey globalKey = GlobalKey();
  final TCConfigs configs;
  final LinkedScrollableControlPoint controlPoint =
      LinkedScrollableControlPoint();
  final List<TCCalendar> calendars;
  final List<TCEvent> events = [];
  late DateTime dateNow = DateTime.now();
  DateTime scopeStartDate = DateTime.now();
  int dayOfWeek = 0;
  State? controller;

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
  State<TCInstance> createState() => controller = _TCTInstanceState();
}

class _TCTInstanceState extends State<TCInstance> {
  @override
  Widget build(BuildContext context) {
    // Create the column of time markers
    final List<Widget> columns = [
      TCTimeMarkerColumn(
        configs: widget.configs,
        controlPoint: widget.controlPoint,
      )
    ];
    // Add the required number of columns to the main view
    columns.addAll(List<Widget>.generate(
      widget.configs.instanceView.columnCount,
      (int index) {
        final DateTime colDateStart =
            widget.scopeStartDate.add(Duration(days: index));
        final DateTime colDateEnd = colDateStart.add(const Duration(hours: 24));
        final Iterable<TCEvent> events = widget.events.where((TCEvent e) =>
            e.dtStart.isAfter(colDateStart) && e.dtEnd.isBefore(colDateEnd));
        return Expanded(
          flex: 2,
          child: TCColumn(
            configs: widget.configs,
            dateInfo: colDateStart,
            controlPoint: widget.controlPoint,
            eventsData: events,
          ),
        );
      },
    ));

    return Material(
      child: Center(
        child: Container(
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight,
          color: widget.configs.primaryColor,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: Column(
              children: [
                TCPanel(
                  tcInstance: widget,
                  configs: widget.configs,
                  controlPoint: widget.controlPoint,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: columns,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
