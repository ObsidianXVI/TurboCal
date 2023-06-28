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
          /* Expanded(
          child: LinkedScrollable(
            isLinked: true,
            controlPoint: widget.controlPoint,
            child: Stack(
              children: [
                ...colItems,
                ...generateEventCanvas(
                  widget.dateInfo,
                  widget.configs.windowWidth /
                      widget.configs.instanceView.columnCount,
                ),
              ],
            ),
          ),
        ), */
          /* Expanded(
          child: LinkedScrollable(
            isLinked: true,
            controlPoint: widget.controlPoint,
            child: Expanded(
              child: Column(
                children: generateEventCanvas(widget.dateInfo),
              ),
            ),
            /* Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: colItems,
                ),
                Column(
                  children: generateEventCanvas(widget.dateInfo),
                ),
                /* Padding(
                  padding: const EdgeInsets.only(right: 10, left: 4),
                  child: Column(
                    children: [
                      Stack(
                        children: generateEventCanvas(widget.dateInfo),
                      ),
                    ],
                  ),
                ), */
              ],
            ), */
          ),
        ), */
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
      /* if (prevEvent != null) {
        if (event.overlapsWith(prevEvent)) {
          print('oveerlap');
          overlapCount += 1;
        } else {
          overlapCount -= 1;
        }
      } */
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

    /* for (TCEvent event in widget.eventsData) {
        canvasElements.addAll(eventBlock(event, currentDay));
      } */

    return canvasElements;
  }

  Widget eventBlock({
    required TCEvent event,
    required DateTime currentDay,
    required int overlapCount,
    required double blockWidth,
  }) {
    return Positioned(
      top: (event.dtEnd.difference(currentDay).inMinutes / 60) *
          widget.configs.timescaleZoom.blockHeight,
      left: (2 * overlapCount) as double,
      height: ((event.dtEnd.difference(event.dtStart).inMinutes) / 60) *
          widget.configs.timescaleZoom.blockHeight,
      width: blockWidth,
      child: Container(
        decoration: BoxDecoration(
          color: event.calendar.semanticColor.color.withOpacity(0.3),
          border: Border(
            left: BorderSide(
              width: 4,
              color: event.calendar.semanticColor.color,
            ),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 2,
              left: 3,
              child: Text(
                event.summary,
                style: TextStyle(
                  color: event.calendar.semanticColor.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    /* Center(
        child: Container(
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(width: (2 * overlapCount) as double),
              ],
          ),
        ),
      ), */
  }
}
