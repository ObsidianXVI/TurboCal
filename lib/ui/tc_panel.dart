part of turbocal;

class TCPanel extends StatelessWidget {
  final LinkedScrollableControlPoint controlPoint;
  final TCConfigs configs;

  TCPanel({required this.configs, required this.controlPoint, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        height: 80,
        color: configs.panelColor,
      ),
    );
  }
}
