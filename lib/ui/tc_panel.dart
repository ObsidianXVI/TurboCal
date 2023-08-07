part of turbocal;

const double tcPanelHeight = 80;

class TCPanel extends StatelessWidget {
  final TCConfigs configs;
  final TCInstance tcInstance;

  TCPanel({
    required this.tcInstance,
    required this.configs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: configs.windowWidth,
        height: tcPanelHeight,
        color: configs.panelColor,
        child: Stack(
          children: [
            Positioned(
              right: 40,
              bottom: 10,
              child: IconButton(
                onPressed: () {
                  ScopeStartDateChangeNotification(
                    newScopeStartDate: tcInstance.scopeStartDate.subtract(
                      const Duration(days: 7),
                    ),
                  ).dispatch(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton(
                onPressed: () {
                  ScopeStartDateChangeNotification(
                    newScopeStartDate: tcInstance.scopeStartDate.add(
                      const Duration(days: 7),
                    ),
                  ).dispatch(context);
                },
                icon: const Icon(
                  Icons.chevron_right,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
