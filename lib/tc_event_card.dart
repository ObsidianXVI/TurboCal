part of turbocal;

class EventCardKey extends LocalKey {
  final TCEventCanvasState eventCanvas;
  final TCRenderData renderData;
  final TCTimescaleZoom timescaleZoom;
  final bool hasRenderPriority;

  const EventCardKey({
    required this.renderData,
    required this.eventCanvas,
    required this.timescaleZoom,
    this.hasRenderPriority = false,
  });
}

class TCEventCard extends StatefulWidget {
  final TCEventCanvasState eventCanvas;
  final TCRenderData renderData;
  final bool hasRenderPriority;
  final TCTimescaleZoom timescaleZoom;

  TCEventCard({
    required this.renderData,
    required this.eventCanvas,
    required this.timescaleZoom,
    this.hasRenderPriority = false,
  }) : super(
          key: EventCardKey(
            eventCanvas: eventCanvas,
            renderData: renderData,
            hasRenderPriority: hasRenderPriority,
            timescaleZoom: timescaleZoom,
          ),
        );

  @override
  State<TCEventCard> createState() => TCEventCardState();
}

class TCEventCardState extends State<TCEventCard> {
  late double height;
  Duration tmp = Duration.zero;
  double startPos = 0;
  double posDelta = 0;

  @override
  void initState() {
    height = widget.renderData.height;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.renderData.width,
      height: height,
      decoration: BoxDecoration(
        color:
            widget.hasRenderPriority ? Colors.red : Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: const Border(
          left: BorderSide(color: Colors.red, width: eventCardBorderWidth),
        ),
        boxShadow: widget.hasRenderPriority
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Positioned(
            top: eventTitlePadding + 5,
            left: eventTitlePadding + eventCardBorderWidth,
            child: Text(widget.renderData.event.summary),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: widget.renderData.width,
              height: 5,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    startPos = details.localPosition.dy;
                  },
                  onVerticalDragUpdate: (details) {
                    // If positive, the start handle was made earlier
                    posDelta = startPos - details.localPosition.dy;
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      height -= posDelta;
                      final newEvent = TCEvent.cloneFrom(
                        widget.renderData.event,
                        dtStart: widget.renderData.event.dtStart.subtract(
                            widget.timescaleZoom.heightToMinutes(posDelta)),
                      );

                      (instanceKey.currentWidget as TCInstance)
                              .eventsRegistry[widget.renderData.event.uid] =
                          newEvent;
                      (instanceKey.currentState as TCInstanceState)
                          .setState(() {});
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: widget.renderData.width,
              height: 5,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeUpDown,
                child: GestureDetector(
                  onVerticalDragStart: (details) {
                    startPos = details.localPosition.dy;
                  },
                  onVerticalDragUpdate: (details) {
                    // If positive, the end handle was made later
                    posDelta = details.localPosition.dy - startPos;
                  },
                  onVerticalDragEnd: (details) {
                    setState(() {
                      height += posDelta;
                      (instanceKey.currentWidget as TCInstance)
                              .eventsRegistry[widget.renderData.event.uid] =
                          TCEvent.cloneFrom(
                        widget.renderData.event,
                        dtEnd: widget.renderData.event.dtEnd.add(
                            widget.timescaleZoom.heightToMinutes(posDelta)),
                      );

                      (instanceKey.currentState as TCInstanceState)
                          .setState(() {});
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
