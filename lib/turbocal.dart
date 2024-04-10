library turbocal;

import 'package:flutter/material.dart';
part './tc_instance.dart';
part './tc_column.dart';
part './tc_event_canvas.dart';
part './tc_event_card.dart';
part './cal_objects.dart';
part './configs.dart';
part './utils.dart';

typedef TCWidgetBuilder<T> = Widget Function(T data, BuildContext cx);



/* class CollisionGroup {
  final List<TCEvent> events = [];
  DateTime start;
  DateTime end;

  CollisionGroup({
    required this.start,
    required this.end,
  });

  void addEvent(TCEvent event) {

  }
} */
