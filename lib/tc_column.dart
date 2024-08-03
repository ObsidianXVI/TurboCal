part of turbocal;

class TCColumnKey extends LocalKey {
  final double blockWidth;
  final double blockHeight;
  final List<TCEvent> events;
  final TCConfigs configs;
  final DateTime dayStamp;

  const TCColumnKey({
    required this.configs,
    required this.blockWidth,
    required this.blockHeight,
    required this.events,
    required this.dayStamp,
  });
}

class TCColumn extends StatefulWidget {
  final double blockWidth;
  final double blockHeight;
  final List<TCEvent> events;
  final TCConfigs configs;
  final DateTime dayStamp;

  TCColumn({
    required this.configs,
    required this.blockWidth,
    required this.blockHeight,
    required this.events,
    required this.dayStamp,
  }) : super(
          key: TCColumnKey(
            configs: configs,
            blockWidth: blockWidth,
            blockHeight: blockHeight,
            events: events,
            dayStamp: dayStamp,
          ),
        );

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
    return DragTarget<TCEvent>(
      onMove: (details) {},
      onWillAccept: (_) => true,
      onAccept: (event) {
        // old - new
        // negative if event is moved forward in time
        final Duration deltaShift =
            event.dtStart.midnight.difference(widget.dayStamp);

        instanceKey.eventsRegistry
          ..remove(event.uid)
          ..addAll({
            event.uid: TCEvent.cloneFrom(
              event,
              dtStart: event.dtStart.subtract(deltaShift),
              dtEnd: event.dtEnd.subtract(deltaShift),
            )
          });

        instanceKey.refreshInstance();
      },
      builder: (context, candidateData, rejectedData) {
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
      },
    );
  }
}
