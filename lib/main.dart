import './turbocal.dart';
import 'package:flutter/material.dart';

final TCCalendar testCal = TCCalendar(
  primaryColor: TCSemanticColor(color: Colors.lightBlue.shade300),
  accentColor: const TCSemanticColor(color: Colors.white),
);
const Duration offsetTime = Duration(hours: 8);

void main() {
  final DateTime now = DateTime.now().localisedTime(offsetTime);

  testCal.events.addAll([
    TCEvent(
      summary: "First Event",
      dtStart: now,
      dtEnd: now.add(const Duration(minutes: 90)),
      uid: "abc1",
      created: utcDate(DateTime.parse("20230511T091320Z")),
      lastModified: utcDate(DateTime.parse("20230511T091320Z")),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: utcDate(DateTime.parse("20230511T091500Z")),
      calendar: testCal,
    ),
/*     TCEvent(
      summary: "event1",
      dtStart: now.subtract(const Duration(hours: 1)),
      dtEnd: now.add(const Duration(minutes: 90)),
      uid: "abc1",
      created: utcDate(DateTime.parse("20230511T091320Z")),
      lastModified: utcDate(DateTime.parse("20230511T091320Z")),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: utcDate(DateTime.parse("20230511T091500Z")),
      calendar: testCal,
    ),
    TCEvent(
      summary: "event2",
      dtStart: now.subtract(const Duration(hours: 1)),
      dtEnd: now.add(const Duration(minutes: 90)),
      uid: "abc2",
      created: utcDate(DateTime.parse("20230511T091320Z")),
      lastModified: utcDate(DateTime.parse("20230511T091320Z")),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: utcDate(DateTime.parse("20230511T091500Z")),
      calendar: testCal,
    ),
    TCEvent(
      summary: "event3",
      dtStart: now
          .subtract(const Duration(hours: 1))
          .subtract(const Duration(days: 3)),
      dtEnd: now
          .add(const Duration(minutes: 90))
          .subtract(const Duration(days: 3)),
      uid: "abc3",
      created: DateTime.parse("20230511T091320Z"),
      lastModified: DateTime.parse("20230511T091320Z"),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: DateTime.parse("20230511T091500Z"),
      calendar: testCal,
    ),
    TCEvent(
      summary: "event4",
      dtStart:
          now.add(const Duration(days: 1)).subtract(const Duration(hours: 1)),
      dtEnd: now.add(const Duration(days: 1)),
      uid: "abc4",
      created: DateTime.parse("20230511T091320Z"),
      lastModified: DateTime.parse("20230511T091320Z"),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: DateTime.parse("20230511T091500Z"),
      calendar: testCal,
    ),
    TCEvent(
      summary: "event5",
      dtStart: now
          .subtract(const Duration(days: 5))
          .subtract(const Duration(hours: 1)),
      dtEnd: now.subtract(const Duration(days: 5)),
      uid: "abc5",
      created: DateTime.parse("20230511T091320Z"),
      lastModified: DateTime.parse("20230511T091320Z"),
      sequence: 0,
      status: TCEventStatus.confirmed,
      transp: TCEventTransp.opaque,
      dtStamp: DateTime.parse("20230511T091500Z"),
      calendar: testCal,
    ),
   */
  ]);
  TCConfigs tcConfigs = TCConfigs(
    calendars: [testCal],
    instanceView: TCInstanceView.week,
    timescaleZoom: TCTimescaleZoom.x100,
    primaryColor: Colors.white,
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
        ),
      ),
    );
  }
}
