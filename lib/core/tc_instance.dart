part of turbocal;

//DateTime.now().hour - 1
class TCInstance extends StatefulWidget {
  final TCConfigs configs;
  late final DateTime dateNow = DateTime.now().localisedTime(offsetTime);
  late DateTime scopeStartDate;
  int dayOfWeek = 0;

  TCInstance({
    required this.configs,
    super.key,
  }) {
    dayOfWeek = dateNow.weekday;
    scopeStartDate = dateNow.subtract(Duration(days: dayOfWeek - 1)).startOfDay;
  }

  @override
  State<TCInstance> createState() => _TCTInstanceState();

  Iterable<TCEvent> get events => configs.synchroniser.repository.values;
}

class _TCTInstanceState extends State<TCInstance> {
  final ScrollController scrollController = ScrollController();
  Widget? eventPreviewOverlay;

  void scrollCanvasToDefault() {
    final double defaultOffset;
    if (widget.configs.defaultBlockNum != null) {
      defaultOffset = widget.configs.defaultBlockNum! *
          widget.configs.timescaleZoom.blockHeight;
    } else {
      if (widget.configs.scrollToCurrentTime) {
        defaultOffset = (DateTime.now().localisedTime(offsetTime).hour - 1) *
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
    final double blockWidth = (widget.configs.windowWidth - 50) /
        widget.configs.instanceView.columnCount;
    // List of the columns to be displayed in the main view
    final List<Widget> columns = [];
    // List of the day and date labels for each column
    final List<Widget> colLabels = [];
    for (int i = 0; i < widget.configs.instanceView.columnCount; i++) {
      final DateTime colDateStart =
          widget.scopeStartDate.add(Duration(days: i));
      final DateTime colDateEnd = colDateStart.add(const Duration(hours: 24));

      final Widget colLabel = Container(
        width: blockWidth,
        height: 50,
        color: widget.configs.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              colDateStart.dayName.substring(0, 3).toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                color: widget.configs.metaColor,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              colDateStart.day.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 18,
                color: widget.configs.metaColor,
              ),
            ),
          ],
        ),
      );

      final Iterable<TCEvent> events =
          widget.events.where((TCEvent e) => e.shouldRenderFor(colDateStart));
      columns.add(
        TCColumn(
          configs: widget.configs,
          dateInfo: colDateStart,
          eventsData: events,
          masterScrollController: scrollController,
        ),
      );
      colLabels.add(colLabel);
    }

    return Material(
      child: Center(
        child: Container(
          width: widget.configs.windowWidth,
          height: widget.configs.windowHeight,
          color: widget.configs.primaryColor,
          child: ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: NotificationListener(
              onNotification: (Object? notif) {
                if (notif is ScopeStartDateChangeNotification) {
                  setState(() {
                    widget.scopeStartDate = notif.newScopeStartDate;
                  });
                } else if (notif is EventCardPressedNotification) {
                  setState(() {
                    eventPreviewOverlay = TCEventPreviewOverlay(
                      configs: widget.configs,
                      tcEvent: notif.eventData,
                      renderBox: notif.renderBox,
                    );
                  });
                } else if (notif is EventCardDismissedNotification) {
                  setState(() {
                    eventPreviewOverlay = null;
                  });
                } else if (notif is EventDataModifiedNotification) {
                  setState(() {});
                }
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
                    top: 80,
                    left: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 0),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(width: 45),
                          ...colLabels,
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
                  if (eventPreviewOverlay != null) eventPreviewOverlay!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
