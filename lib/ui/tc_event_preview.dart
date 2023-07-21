part of turbocal;

class TCEventPreviewOverlay extends StatelessWidget {
  final TCConfigs configs;
  final TCEvent tcEvent;
  final RenderBox renderBox;

  const TCEventPreviewOverlay({
    required this.configs,
    required this.tcEvent,
    required this.renderBox,
    super.key,
  });

  static const double reqWidth = (300 + 20);

  @override
  Widget build(BuildContext context) {
    final Offset eventCardOffset = renderBox.localToGlobal(Offset.zero);
    return Positioned(
      top: eventCardOffset.dy,
      left: eventCardOffset.dx - reqWidth > 0
          ? eventCardOffset.dx - reqWidth
          : eventCardOffset.dx + renderBox.size.width + 20,
      width: 300,
      height: 200,
      child: Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 28,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                tcEvent.summary,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
