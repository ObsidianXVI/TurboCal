part of turbocal;

enum EventCardType {
  standard,
  anticipated,
  outlined,
}

class EventCard extends StatefulWidget {
  final TCEvent event;
  final TCConfigs configs;
  final double itemHeight;
  final double maxWidth;
  final EventCardType cardType;

  const EventCard({
    required this.event,
    required this.configs,
    required this.itemHeight,
    required this.maxWidth,
    this.cardType = EventCardType.standard,
    super.key,
  });

  const EventCard.anticipated({
    required this.event,
    required this.configs,
    required this.itemHeight,
    required this.maxWidth,
    super.key,
  }) : cardType = EventCardType.anticipated;

  const EventCard.outlined({
    required this.event,
    required this.configs,
    required this.itemHeight,
    required this.maxWidth,
    super.key,
  }) : cardType = EventCardType.outlined;

  @override
  State<StatefulWidget> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
  bool draggingByHandles = false;
  bool active = false;
  List<BoxShadow> boxShadows = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      spreadRadius: 2,
      blurRadius: 12,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Widget card = Material(
      child: Container(
        width: widget.maxWidth,
        height: widget.itemHeight,
        decoration: BoxDecoration(
          color: widget.cardType == EventCardType.anticipated ||
                  widget.cardType == EventCardType.outlined
              ? widget.event.calendar.primaryColor.color.withOpacity(0.6)
              : widget.event.calendar.primaryColor.color,
          boxShadow: active ? boxShadows : null,
          border: Border.all(
            width: 1,
            color: widget.cardType == EventCardType.outlined
                ? widget.event.calendar.primaryColor.color
                : widget.event.calendar.accentColor.color,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: SizedBox(
          child: Stack(
            children: [
              Positioned(
                top: 2,
                left: 7,
                child: Text(
                  widget.event.summary,
                  style: TextStyle(
                    color: widget.event.calendar.accentColor.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final MouseRegion mouseRegion = MouseRegion(
      cursor: SystemMouseCursors.resizeUpDown,
      onEnter: (_) => draggingByHandles = true,
      onExit: (_) => draggingByHandles = false,
      child: SizedBox(
        width: widget.maxWidth,
        height: 10,
      ),
    );
    return Draggable<EventCard>(
      data: widget,
      feedback: card,
      onDragUpdate: (DragUpdateDetails details) {
        /*  print(details.localPosition);
        print(details.globalPosition); */
      },
      onDragStarted: () => print("DS: s${widget.event.dtStart}"),
      childWhenDragging: EventCard.outlined(
        event: widget.event,
        configs: widget.configs,
        itemHeight: widget.itemHeight,
        maxWidth: widget.maxWidth,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            active = !active;
            if (active) {
              EventCardPressedNotification(
                eventData: widget.event,
                renderBox: context.findRenderObject() as RenderBox,
              ).dispatch(context);
            } else {
              const EventCardDismissedNotification().dispatch(context);
            }
          });
        },
        child: Stack(
          children: [
            card,
            Positioned(
              top: 0,
              left: 0,
              width: widget.maxWidth,
              height: 10,
              child: mouseRegion,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              width: widget.maxWidth,
              height: 10,
              child: mouseRegion,
            ),
          ],
        ),
      ),
    );
  }
}
