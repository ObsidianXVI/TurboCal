part of turbocal;

class TCColumn extends StatefulWidget {
  final TCConfigs configs;
  final String dayLabel;
  final String dateLabel;
  final LinkedScrollableControlPoint controlPoint;
  const TCColumn({
    required this.configs,
    required this.dayLabel,
    required this.dateLabel,
    required this.controlPoint,
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
                widget.dayLabel,
                style: TextStyle(
                  fontSize: 24,
                  color: widget.configs.metaColor,
                ),
              ),
              const SizedBox(width: 20),
              Text(
                widget.dateLabel,
                style: TextStyle(
                  fontSize: 18,
                  color: widget.configs.metaColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: LinkedScrollable(
            isLinked: true,
            controlPoint: widget.controlPoint,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: colItems,
            ),
          ),
        ),
      ],
    );
  }
}
