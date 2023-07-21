part of turbocal;

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
        height: 80,
        color: configs.panelColor,
        child: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 10,
              child: IconButton(
                onPressed: () {
                  TurbocalNotification(
                    notifications: [
                      ScopeStartDateChangeNotification(
                        newScopeStartDate: tcInstance.scopeStartDate.subtract(
                          const Duration(days: 7),
                        ),
                      ),
                    ],
                  ).dispatch(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
