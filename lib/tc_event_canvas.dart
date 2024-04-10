part of turbocal;

class TCEventCanvas extends StatefulWidget {
  final DateTime dayStamp;
  final double maxWidth;
  final TCConfigs configs;
  final List<TCEvent> events;

  const TCEventCanvas({
    required this.maxWidth,
    required this.configs,
    required this.events,
    required this.dayStamp,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => TCEventCanvasState();
}

class TCEventCanvasState extends State<TCEventCanvas> {
  final List<TCEvent> sortedEvents = [];
  final List<TCRenderData> flattenedLayers = [];

  void init() {
    if (widget.events.isEmpty) return;
    if (widget.events.length == 1) {
      sortedEvents.add(widget.events[0]);
    } else {
      sortedEvents
        ..addAll(widget.events)
        ..sort((a, b) => b.dtStart.compareTo(a.dtStart));
    }
    flattenedLayers.addAll(flattenLayers(resolveCollisions()));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void resetState() {
    sortedEvents.clear();
    flattenedLayers.clear();
  }

  List<List<TCRenderData>> resolveCollisions() {
    final List<List<TCRenderData>> layers = [];
    int layer = 0;
    DateTime prevDt;
    while (sortedEvents.isNotEmpty) {
      final TCEvent ev = sortedEvents.first;
      layers.add([
        TCRenderData(
          width: widget.maxWidth,
          height: widget.configs.timescaleZoom
              .minutesToHeight(ev.durationSpan.inMinutes),
          offset: widget.configs.timescaleZoom.minutesToHeight(
            ev.dtStart.difference(widget.dayStamp).inMinutes,
          ),
          event: ev,
        )
      ]);

      prevDt = ev.dtStart;
      sortedEvents.removeAt(0);
      if (sortedEvents.isNotEmpty) {
        for (int i = 0; i < sortedEvents.length; i++) {
          final TCEvent ev = sortedEvents[i];
          if (!ev.dtStart.isAfter(
              prevDt.add(widget.configs.timescaleZoom.heightToMinutes(20)))) {
            continue;
          } else {
            layers[layer].add(
              TCRenderData(
                width: widget.maxWidth - (indentSize * layer),
                event: ev,
                height: widget.configs.timescaleZoom
                    .minutesToHeight(ev.durationSpan.inMinutes),
                offset: widget.configs.timescaleZoom.minutesToHeight(
                  ev.dtStart.difference(widget.dayStamp).inMinutes,
                ),
              ),
            );
          }
        }
        layer += 1;
      } else {
        return layers;
      }
    }
    return layers;
  }

  List<TCRenderData> flattenLayers(List<List<TCRenderData>> layers) {
    final List<TCRenderData> flattened = [];
    for (int i = 0; i < layers.length; i++) {
      for (int j = 0; j < layers[i].length; j++) {
        flattened.add(layers[i][j]);
      }
    }
    return flattened;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: widget.configs.timescaleZoom.blockHeight * 24,
      child: Stack(
        children: [
          for (final e in flattenedLayers)
            Positioned(
              top: e.offset,
              right: 0,
              width: e.width,
              height: e.height,
              child: TCEventCard(renderData: e),
            ),
        ],
      ),
    );
  }
}

class TCRenderData {
  final TCEvent event;
  final double width;
  final double height;
  final double offset;

  const TCRenderData({
    required this.width,
    required this.height,
    required this.offset,
    required this.event,
  });
}
