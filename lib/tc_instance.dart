part of turbocal;

class TCInstance extends StatefulWidget {
  final TCConfigs configs;

  const TCInstance({required this.configs, super.key});

  @override
  State<TCInstance> createState() => _TCTInstanceState();
}

class _TCTInstanceState extends State<TCInstance> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.configs.windowWidth,
        height: widget.configs.windowHeight,
        color: Colors.amber,
        child: SingleChildScrollView(
          child: Center(
            child: Row(
              children: List<Widget>.generate(
                7, // widget.configs.instanceView.columnCount,
                (index) {
                  return Expanded(
                    flex: 2,
                    child: TCColumn(configs: widget.configs),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TCColumn extends StatefulWidget {
  final TCConfigs configs;
  const TCColumn({required this.configs, super.key});

  @override
  State<TCColumn> createState() => _TCColumnState();
}

class _TCColumnState extends State<TCColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(24, (int index) {
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
      }),
    );
  }
}
