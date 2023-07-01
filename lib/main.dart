import './turbocal.dart';
import 'package:flutter/material.dart';

final TCCalendar testCal =
    TCCalendar(semanticColor: const TCSemanticColor(color: Colors.blue));

void main() {
  testCal.events.addAll([
    TCEvent(
      summary: "event1",
      dtStart: DateTime.parse("20230626T104500Z"),
      dtEnd: DateTime.parse("20230626T114500Z"),
      uid: "07ua4sgq0sk1ubb9qs1kji9oau@google.com",
      created: DateTime.parse("20230511T091320Z"),
      lastModified: DateTime.parse("20230511T091320Z"),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: DateTime.parse("20230511T091500Z"),
      calendar: testCal,
    ),
    TCEvent(
      summary: "event2",
      dtStart: DateTime.parse("20230626T113000Z"),
      dtEnd: DateTime.parse("20230626T124500Z"),
      uid: "07ua4sgq0sk1ubb9qs1kji9oau@google.com",
      created: DateTime.parse("20230511T091320Z"),
      lastModified: DateTime.parse("20230511T091320Z"),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: DateTime.parse("20230511T091500Z"),
      calendar: testCal,
    ),
  ]);
  TCConfigs tcConfigs = TCConfigs(
    calendars: [testCal],
    instanceView: TCInstanceView.week,
    timescaleZoom: TCTimescaleZoom.x100,
    primaryColor: Colors.white70,
    secondaryColor: Colors.blueGrey,
    metaColor: Colors.black,
    panelColor: Colors.pink,
    windowWidth: 1900,
    windowHeight: 1200,
    scrollToCurrentTime: true,
  );
  runApp(
    App(
      configs: tcConfigs,
    ),
  );
}

class App extends StatelessWidget {
  final TCConfigs configs;

  App({
    required this.configs,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: TCInstance(
          configs: configs,
          calendars: [testCal],
        ),
      ),
    );
  }
}
