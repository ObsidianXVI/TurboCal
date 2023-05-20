part of turbocal;

class TCInstance extends StatefulWidget {
  final TCConfigs configs;
  final LinkedScrollableControlPoint controlPoint =
      LinkedScrollableControlPoint();

  TCInstance({required this.configs, super.key});

  @override
  State<TCInstance> createState() => _TCTInstanceState();
}

class _TCTInstanceState extends State<TCInstance> {
  final List<String> dayLabels = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  @override
  Widget build(BuildContext context) {
    // Create the column of time markers
    final List<Widget> columns = [
      TCTimeMarkerColumn(
        configs: widget.configs,
        controlPoint: widget.controlPoint,
      )
    ];
    // Add the required number of columns to the main view
    columns.addAll(List<Widget>.generate(
      widget.configs.instanceView.columnCount,
      (int index) {
        return Expanded(
          flex: 2,
          child: TCColumn(
            configs: widget.configs,
            dayLabel: dayLabels[index],
            dateLabel: index.toString().padLeft(2, '0'),
            controlPoint: widget.controlPoint,
          ),
        );
      },
    ));

    return Center(
      child: Container(
        width: widget.configs.windowWidth,
        height: widget.configs.windowHeight,
        color: widget.configs.primaryColor,
        child: Column(
          children: [
            TCPanel(
              configs: widget.configs,
              controlPoint: widget.controlPoint,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: columns,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
