part of turbocal;

class TCEvent {
  final String summary;
  final TCDescription? description;
  final TCLocation? location;
  final DateTime dtStart;
  final DateTime dtEnd;
  final DateTime dtStamp;
  final String uid;
  final DateTime created;
  final DateTime lastModified;
  final int sequence;
  final TCEventStatus status;
  final TCEventTransp transp;
  final TCRepeatRule? repeatRule;
  final List<TCAlarm> alarms;
  final TCCalendar calendar;

  const TCEvent({
    required this.summary,
    required this.dtStart,
    required this.dtEnd,
    required this.uid,
    required this.created,
    required this.lastModified,
    required this.sequence,
    required this.status,
    required this.transp,
    required this.dtStamp,
    required this.calendar,
    this.description,
    this.location,
    this.repeatRule,
    this.alarms = const [],
  });

  TCEvent.cloneFrom(
    TCEvent other, {
    bool updateMeta = true,
  })  : summary = other.summary,
        dtStart = other.dtStart,
        dtEnd = other.dtEnd,
        uid = other.uid,
        created = other.created,
        lastModified = DateTime.now(),
        sequence = other.sequence,
        status = other.status,
        transp = other.transp,
        dtStamp = other.dtStamp,
        calendar = other.calendar,
        description = other.description,
        location = other.location,
        repeatRule = other.repeatRule,
        alarms = other.alarms;

  bool shouldRenderFor(DateTime currentDate) {
    return !(currentDate.isBefore(dtStart) || currentDate.isAfter(dtEnd));
  }

  bool overlapsWith(TCEvent other) {
    return ((dtStart.isAfter(other.dtStart) && dtStart.isBefore(other.dtEnd)) ||
        (dtEnd.isAfter(other.dtStart) && dtEnd.isBefore(other.dtEnd)) ||
        (dtStart.isAtSameMomentAs(other.dtStart)));
  }
}
