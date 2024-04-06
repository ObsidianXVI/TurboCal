library turbocal;

import 'package:flutter/material.dart';
part './cal_objects.dart';
part './configs.dart';

typedef TCWidgetBuilder<T> = Widget Function(T data, BuildContext cx);

class TCInstance extends StatefulWidget {
  final List<TCEvent> events;
  final TCConfigs configs;

  const TCInstance({
    required this.events,
    required this.configs,
    super.key,
  });

  @override
  State<TCInstance> createState() => TCInstanceState();
}

class TCInstanceState extends State<TCInstance> {
  late final int columnCount;

  @override
  void initState() {
    columnCount = widget.configs.instanceView.columnCount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.configs.windowWidth,
        height: widget.configs.windowHeight,
        color: widget.configs.primaryColor,
      ),
    );
  }
}
