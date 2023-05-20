part of turbocal;

class TCInstance extends StatefulWidget {
  final TCConfigs configs;
  final LinkedScrollableControlPoint controlPoint =
      LinkedScrollableControlPoint();
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
        return Expanded(
          flex: 2,
          child: TCColumn(
            configs: widget.configs,
            dateInfo: widget.scopeStartDate.add(
              Duration(days: index),
            ),
            controlPoint: widget.controlPoint,
            eventsData:
                widget.events.where((TCEvent e) => e.dtStart is DateTime),
          ),
        );
      },
    ));

    return Center(
      child: Container(
        width: widget.configs.windowWidth,
        height: widget.configs.windowHeight,
        color: widget.configs.primaryColor,
        child: Column(
          children: [
            TCPanel(
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
    );
  }
}
