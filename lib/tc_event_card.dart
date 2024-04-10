part of turbocal;

class TCEventCard extends StatelessWidget {
  final TCRenderData renderData;

  const TCEventCard({
    required this.renderData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: renderData.width,
      height: renderData.height,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
        border: const Border(
          left: BorderSide(color: Colors.red, width: eventCardBorderWidth),
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            left: eventTitlePadding + eventCardBorderWidth,
            top: eventTitlePadding,
          ),
          child: Text(renderData.event.summary),
        ),
      ),
    );
  }
}
