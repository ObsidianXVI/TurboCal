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
      dtStart: DateTime.parse("20230716T113000Z"),
      dtEnd: DateTime.parse("202300716T124500Z"),
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
    windowWidth: 1450,
    windowHeight: 1200,
    scrollToCurrentTime: true,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Center(
        child: TCInstance(
          configs: TCConfigs(
            calendars: [testCal],
            instanceView: TCInstanceView.week,
            timescaleZoom: TCTimescaleZoom.x100,
            primaryColor: Colors.white70,
            secondaryColor: Colors.blueGrey,
            metaColor: Colors.black,
            panelColor: Colors.pink,
            windowWidth: MediaQuery.of(context).size.width,
            windowHeight: MediaQuery.of(context).size.height,
            scrollToCurrentTime: true,
          ),
          calendars: [testCal],
        ),
      ),
    );
  }
}
