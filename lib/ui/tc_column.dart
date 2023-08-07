part of turbocal;

class TCColumn extends StatefulWidget {
  final TCConfigs configs;
  final DateTime dateInfo;
  final Iterable<TCEvent> eventsData;
  final ScrollController masterScrollController;

  const TCColumn({
    required this.configs,
    required this.dateInfo,
    required this.eventsData,
    required this.masterScrollController,
    super.key,
  });

  @override
  State<TCColumn> createState() => _TCColumnState();
}

class _TCColumnState extends State<TCColumn> {
  Widget? anticiaptionCard;
  EventCard? oldEventCard;
  TCEvent? newEventData;

  @override
  Widget build(BuildContext context) {
    final double blockWidth = (widget.configs.windowWidth - 50) /
        widget.configs.instanceView.columnCount;
    final List<Widget> colItems = [];
    colItems.addAll(List.generate(24, (int index) {
      return Center(
        child: Container(
          width: blockWidth,
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
    return DragTarget<EventCard>(
      onWillAccept: (_) => true,
      onAccept: (EventCard eventCard) {
/*         anticiaptionCard = null;
        print('accepted');
        final TCEvent updatedEvent = TCEvent(
          summary: eventCard.event.summary,
          dtStart:
              eventCard.event.dtStart.changeDayTo(widget.dateInfo.startOfDay),
          dtEnd: eventCard.event.dtEnd,
          uid: eventCard.event.uid,
          created: eventCard.event.created,
          lastModified: eventCard.event.lastModified,
          sequence: eventCard.event.sequence,
          status: eventCard.event.status,
          transp: eventCard.event.transp,
          dtStamp: eventCard.event.dtStamp,
          calendar: eventCard.event.calendar,
        );
        widget.configs.synchroniser.update(updatedEvent);
        print("Updated dtStart: ${updatedEvent.dtStart}");
        const EventDataModifiedNotification().dispatch(context); */
      },
      onLeave: (_) {
        oldEventCard = null;
        newEventData = null;
      },
      onMove: (DragTargetDetails<EventCard> details) {
        final TCEvent oldEvent = details.data.event;
        final double heightFromTopOfCanvas =
            widget.masterScrollController.offset +
                details.offset.dy -
                tcPanelHeight -
                widget.configs.timescaleZoom.blockHeight;
        final DateTime newDtStart = widget.dateInfo.add(
          Duration(
            minutes: computeMinutesFromTop(
              heightFromTop: heightFromTopOfCanvas,
              roundTo: 15,
            ).toInt(),
          ),
        );
        print(newDtStart);
        oldEventCard = details.data;
        newEventData = TCEvent.cloneFrom(
          oldEvent,
          dtStart: newDtStart,
          dtEnd: newDtStart.add(oldEvent.durationSpan),
          updateMeta: false,
        );
      },
      builder: (BuildContext context, candidateData, rejectedData) {
        return Column(
          children: [
            SizedBox(height: widget.configs.timescaleZoom.blockHeight),
            SizedBox(
              height: widget.configs.timescaleZoom.blockHeight * 24,
              width: blockWidth,
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
                  ...generateEventCanvas(
                    widget.dateInfo,
                    blockWidth,
                    [
                      if (candidateData.isNotEmpty) newEventData!,
                      ...widget.eventsData.toList(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> generateEventCanvas(
    DateTime currentDay,
    double blockWidth,
    List<TCEvent> events,
  ) {
    final List<Widget> canvasElements = [];
    final List<TCEvent> remEvents = events
      ..sort((TCEvent event1, TCEvent event2) {
        return event1.dtStart.compareTo(event2.dtStart);
      });

    for (TCEvent event in remEvents) {
      final double itemHeight =
          ((event.dtEnd.difference(event.dtStart).inMinutes) / 60) *
              widget.configs.timescaleZoom.blockHeight;
      canvasElements.add(
        Positioned(
          top: computeHeightFromTop(
            currentDay: currentDay,
            event: event,
          ),
          left: 4,
          right: 10,
          height: itemHeight,
          child: EventCard(
            itemHeight: itemHeight,
            event: event,
            configs: widget.configs,
            maxWidth: blockWidth - 4 - 10,
          ),
        ),
      );
    }
    return canvasElements;
  }

  double computeHeightFromTop({
    required TCEvent event,
    required DateTime currentDay,
  }) {
    return (event.dtEnd.difference(currentDay).inMinutes / 60) *
        widget.configs.timescaleZoom.blockHeight;
  }

  double computeMinutesFromTop({
    required double heightFromTop,
    int? roundTo = 15,
  }) {
    final double height =
        (heightFromTop / widget.configs.timescaleZoom.blockHeight);
    return (roundTo != null ? height.roundToNearestStep(roundTo) : height) * 60;
  }

  Widget showUpdatedEvent({
    required EventCard oldCard,
    required TCEvent oldEvent,
  }) {
    final TCEvent updatedEvent = TCEvent.cloneFrom(oldEvent)
      ..dtStart.add(
        widget.dateInfo.difference(oldEvent.dtStart),
      );
    return Positioned(
      top: computeHeightFromTop(
            event: updatedEvent,
            currentDay: updatedEvent.dtStart.startOfDay,
          ) +
          313,
      left: 4,
      right: 10,
      child: SizedBox(
        height: oldCard.itemHeight,
        width: oldCard.maxWidth,
        child: EventCard(
          event: updatedEvent,
          configs: widget.configs,
          itemHeight: oldCard.itemHeight,
          maxWidth: oldCard.maxWidth,
        ),
      ),
    );
  }
}
