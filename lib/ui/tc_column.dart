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
    return Column(
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
              LinkedScrollable(
                isLinked: true,
                controlPoint: widget.controlPoint,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: colItems,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 4),
                      child: Column(
                        children: generateEventCanvas(widget.dateInfo),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> generateEventCanvas(DateTime currentDay) {
    final List<Widget> eventBlocks = [];
    for (TCEvent event in widget.eventsData) {
      eventBlocks.add(
        SizedBox(
          height: (event.dtEnd.difference(currentDay).inMinutes / 60) *
              widget.configs.timescaleZoom.blockHeight,
        ),
      );
      eventBlocks.add(
        Container(
          height: ((event.dtEnd.difference(event.dtStart).inMinutes) / 60) *
              widget.configs.timescaleZoom.blockHeight,
          decoration: BoxDecoration(
              color: event.calendar.semanticColor.color.withOpacity(0.6),
              border: Border(
                left: BorderSide(
                    width: 4, color: event.calendar.semanticColor.color),
              )),
        ),
      );
    }
    return eventBlocks;
  }
}
