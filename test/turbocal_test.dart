import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:turbocal/turbocal.dart';

void main() {
  final TCCalendar testCal = TCCalendar(
    semanticColor: TCSemanticColor(color: Colors.pink[400]!),
    events: [
      TCEvent(
        summary: "event1",
        dtStart: DateTime.parse("20230511T040000Z"),
        dtEnd: DateTime.parse("20230511T050000Z "),
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
}
