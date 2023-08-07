part of turbocal;

class DimensionTools {
  static double getHeight(BuildContext context) {
    final padding = MediaQuery.of(context).viewPadding;
    final height = MediaQuery.of(context).size.height;
    return height - padding.top;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}

DateTime utcDate(DateTime dt) {
  return DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
}

extension DateTimeUtils on DateTime {
  String get dayName {
    switch (weekday) {
      case 1:
        return 'monday';
      case 2:
        return 'tuesday';
      case 3:
        return 'wednesday';
      case 4:
        return 'thursday';
      case 5:
        return 'friday';
      case 6:
        return 'saturday';
      case 7:
        return 'sunday';
      default:
        return 'NULL';
    }
  }

  DateTime get startOfDay => DateTime.utc(year, month, day);

  DateTime changeDayTo(DateTime targetDay) {
    final dayOfThis = startOfDay;
    print('changing day');
    if (targetDay.isAfter(dayOfThis)) {
      print("    Current: $dayOfThis");
      print("    New    : $targetDay");
      print("    ∆Hours : ${targetDay.difference(this).inHours}");
      return add(targetDay.difference(this));
    } else {
      print("    Current: $dayOfThis");
      print("    New    : $targetDay");
      print("    ∆Hours : ${difference(targetDay).inHours}");
      return subtract(difference(targetDay));
    }
  }
}

extension DoubleUtils on double {
  int roundToNearestStep(int stepSize) => (this / stepSize).floor() * stepSize;
}
