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
    return Column(
      children: [
        SizedBox(height: widget.configs.timescaleZoom.blockHeight - 15),
        ...List.generate(24, (int index) {
          final Text timeMarker = Text(
            "${index.toString().padLeft(2, '0')}:00",
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: widget.configs.fontSize,
              fontFamily: widget.configs.fontFamily,
              color: widget.configs.metaColor,
            ),
          );
          return Center(
            child: Container(
              width: 45,
              height: widget.configs.timescaleZoom.blockHeight,
              color: widget.configs.primaryColor,
              child: timeMarker,
            ),
          );
        }),
      ],
    );
  }
}
