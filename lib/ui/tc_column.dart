part of turbocal;

class TCColumn extends StatefulWidget {
  final TCConfigs configs;
  final DateTime dateInfo;

  final LinkedScrollableControlPoint controlPoint;
  final Iterable<TCEvent> eventsData;

  const TCColumn({
    required this.configs,
    required this.dateInfo,
    required this.controlPoint,
    required this.eventsData,
    super.key,
  });

  @override
  State<TCColumn> createState() => _TCColumnState();
}

class _TCColumnState extends State<TCColumn> {
  @override
  Widget build(BuildContext context) {
    final double blockWidth =
        widget.configs.windowWidth / widget.configs.instanceView.columnCount;
    final List<Widget> colItems = [];
    colItems.addAll(List.generate(24, (int index) {
      return Center(
        child: Container(
          width: double.infinity,
          height: widget.configs.timescaleZoom.blockHeight,
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.configs.secondaryColor,
              width: 0.1,
            ),
            color: widget.configs.primaryColor,
          ),
        ),
      );
    }));
    return LinkedScrollable(
      isLinked: true,
      controlPoint: widget.controlPoint,
      height: widget.configs.windowHeight,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: widget.configs.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.dateInfo.dayName.substring(0, 3).toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.configs.metaColor,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  widget.dateInfo.day.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 18,
                    color: widget.configs.metaColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: blockWidth,
                    height: widget.configs.timescaleZoom.blockHeight * 24,
                    child: Column(
                      children: colItems,
                    ),
                  ),
                ),
                ...generateEventCanvas(widget.dateInfo, blockWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> generateEventCanvas(DateTime currentDay, double blockWidth) {
    final List<Widget> canvasElements = [];
    final List<TCEvent> remEvents = widget.eventsData.toList()
      ..sort((TCEvent event1, TCEvent event2) {
        return event1.dtStart.compareTo(event2.dtStart);
      });

    TCEvent? prevEvent;
    int overlapCount = 0;
    for (TCEvent event in remEvents) {
      if (prevEvent != null) {
        if (event.overlapsWith(prevEvent)) {
          overlapCount += 1;
        } else {
          overlapCount -= 1;
        }
      }
      canvasElements.add(
        eventBlock(
          event: event,
          currentDay: currentDay,
          overlapCount: overlapCount,
          blockWidth: blockWidth,
        ),
      );
      prevEvent = event;
    }

    return canvasElements;
  }

  Widget eventBlock({
    required TCEvent event,
    required DateTime currentDay,
    required int overlapCount,
    required double blockWidth,
  }) {
    final double itemHeight =
        ((event.dtEnd.difference(event.dtStart).inMinutes) / 60) *
            widget.configs.timescaleZoom.blockHeight;
    return Positioned(
      top: (event.dtEnd.difference(currentDay).inMinutes / 60) *
          widget.configs.timescaleZoom.blockHeight,
      left: 4 + (8 * overlapCount) as double,
      right: 10,
      height: itemHeight,
      child: EventCard(
        itemHeight: itemHeight,
        event: event,
        configs: widget.configs,
      ),
    );
  }
}
