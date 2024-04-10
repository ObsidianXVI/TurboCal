part of turbocal;

class TCColumn extends StatefulWidget {
  final double blockWidth;
  final double blockHeight;
  final List<TCEvent> events;
  final TCConfigs configs;
  final DateTime dayStamp;

  const TCColumn({
    required this.configs,
    required this.blockWidth,
    required this.blockHeight,
    required this.events,
    required this.dayStamp,
    super.key,
  });

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
  }
}