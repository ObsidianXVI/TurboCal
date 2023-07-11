part of turbocal;

class TCTimeMarkerColumn extends StatefulWidget {
  final TCConfigs configs;
  const TCTimeMarkerColumn({
    required this.configs,
    super.key,
  });

  @override
  State<TCTimeMarkerColumn> createState() => _TCTimeMarkerColumnState();
}

class _TCTimeMarkerColumnState extends State<TCTimeMarkerColumn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.configs.windowHeight,
      width: 50,
      child: Column(
        children: List.generate(24, (int index) {
          final Text timeMarker = index == 0
              ? const Text('')
              : Text(
                  "${index.toString().padLeft(2, '0')}:00",
                  style: TextStyle(
                    fontSize: widget.configs.fontSize,
                    fontFamily: widget.configs.fontFamily,
                    color: widget.configs.metaColor,
                  ),
                );
          return Center(
            child: Container(
              width: 50,
              height: widget.configs.timescaleZoom.blockHeight,
              color: widget.configs.primaryColor,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 5,
                    top: -6,
                    child: timeMarker,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
