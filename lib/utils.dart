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

enum MonthLabels {
  january('Jan', 'January'),
  february('Feb', 'February'),
  march('Mar', 'March'),
  april('Apr', 'April'),
  may('May', 'May'),
  june('Jun', 'June'),
  july('Jul', 'July'),
  august('Aug', 'August'),
  september('Sept', 'September'),
  october('Oct', 'October'),
  november('Nov', 'November'),
  december('Dec', 'December');

  final String shortName;
  final String longName;
  const MonthLabels(this.shortName, this.longName);
}

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
