part of turbocal;

enum TCEventStatus { confirmed }

enum TCEventTransp { opaque }

class TCAlarm {}

class TCRepeatRule {}

class TCCalendar {}

class TCEvent {
  final String summary;
  final String? description;
  final String? location;
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
    String? summary,
    String? description,
    String? location,
    DateTime? dtStart,
    DateTime? dtEnd,
    DateTime? dtStamp,
    String? uid,
    DateTime? created,
    DateTime? lastModified,
    int? sequence,
    TCEventStatus? status,
    TCEventTransp? transp,
    TCRepeatRule? repeatRule,
    List<TCAlarm>? alarms,
    TCCalendar? calendar,
    bool updateMeta = true,
  })  : summary = summary ?? other.summary,
        dtStart = dtStart ?? other.dtStart,
        dtEnd = dtEnd ?? other.dtEnd,
        uid = uid ?? other.uid,
        created = created ?? other.created,
        lastModified = lastModified ?? DateTime.now(),
        sequence = sequence ?? other.sequence,
        status = status ?? other.status,
        transp = transp ?? other.transp,
        dtStamp = dtStamp ?? other.dtStamp,
        calendar = calendar ?? other.calendar,
        description = description ?? other.description,
        location = location ?? other.location,
        repeatRule = repeatRule ?? other.repeatRule,
        alarms = alarms ?? other.alarms;

  Duration get durationSpan => dtEnd.difference(dtStart);
}
