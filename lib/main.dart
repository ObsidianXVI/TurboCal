import './turbocal.dart';
import 'package:flutter/material.dart';

void main() {
  /* final TCCalendar testCal = TCCalendar(
    semanticColor: const TCSemanticColor(color: Colors.pink),
    events: [
      TCEvent(
        summary: "event1",
        dtStart: DateTime.parse("20230511T040000Z"),
        dtEnd: DateTime.parse("20230511T040000Z "),
        uid: "07ua4sgq0sk1ubb9qs1kji9oau@google.com",
        created: DateTime.parse("20230511T091320Z"),
        lastModified: DateTime.parse("20230511T091320Z"),
        sequence: 0,
        status: TCEventStatus.confirmed,
        transp: TCEventTransp.opaque,
        dtStamp: DateTime.parse("20230511T091500Z"),
      ),
    ],
  );
  */
  final TCConfigs tcConfigs = TCConfigs(
    calendars: [],
    instanceView: TCInstanceView.week,
    timescaleZoom: TCTimescaleZoom.x100,
    primaryColor: Colors.white70,
    secondaryColor: Colors.blueGrey,
    windowWidth: 1900,
    windowHeight: 1200,
  );
  runApp(App(
    configs: tcConfigs,
  ));
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
        child: TCInstance(configs: configs),
      ),
    );
  }
}
