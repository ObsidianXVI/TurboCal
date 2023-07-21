part of turbocal;

class EventCard extends StatefulWidget {
  final TCEvent event;
  final TCConfigs configs;
  final double itemHeight;

  const EventCard({
    required this.event,
    required this.configs,
    required this.itemHeight,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => EventCardState();
}

class EventCardState extends State<EventCard> {
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
    return InkWell(
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
      child: Container(
        decoration: BoxDecoration(
          color: widget.event.calendar.primaryColor.color,
          boxShadow: active ? boxShadows : null,
          border: Border.all(
            width: 1,
            color: widget.event.calendar.accentColor.color,
          ),
        ),
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
    );
  }
}
