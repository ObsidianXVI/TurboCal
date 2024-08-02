import 'package:flutter/material.dart';

import 'package:turbocal/turbocal.dart';

final TCCalendar defaultCalendar = TCCalendar();
void main() {
  runApp(
    TCInstance(
      events: [
        TCEvent(
          summary: "First Event",
          dtStart: DateTime(2024, 8, 11, 17, 30).toUtc(),
          dtEnd: DateTime(2024, 8, 11, 17, 30)
              .toUtc()
              .add(const Duration(minutes: 90)),
          uid: "abc1",
          created: DateTime(2024, 6, 12, 17, 0).toUtc(),
          lastModified: now(),
          sequence: 0,
          status: TCEventStatus.confirmed,
          transp: TCEventTransp.opaque,
          dtStamp: now(),
          calendar: defaultCalendar,
        ),
      ],
      configs: TCConfigs(
        instanceView: TCInstanceView.week,
        timescaleZoom: TCTimescaleZoom.x100,
        primaryColor: Colors.white70,
        secondaryColor: Colors.grey,
        panelColor: Colors.purple,
        metaColor: Colors.blue,
        windowHeight: 800,
        windowWidth: 1200,
      ),
    ),
  );
}
