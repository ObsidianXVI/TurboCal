part of turbocal;

const List<String> dayLabels = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun'
];

DateTime now() => DateTime.now().toUtc();

extension DateTimeUtils on DateTime {
  String get dayName {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'NULL';
    }
  }
}

extension NumUtils on num {
  String toDoubleDigitZeroPadded() => toString().padLeft(2, '0');
}
