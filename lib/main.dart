import 'package:flutter/material.dart';

import 'package:turbocal/turbocal.dart';

void main() {
  runApp(
    TCInstance(
      events: [],
      configs: TCConfigs(
        instanceView: TCInstanceView.week,
        timescaleZoom: TCTimescaleZoom.x100,
        primaryColor: Colors.grey,
        secondaryColor: Colors.pink,
        panelColor: Colors.purple,
        metaColor: Colors.blue,
        windowHeight: 800,
        windowWidth: 1200,
      ),
    ),
  );
}
