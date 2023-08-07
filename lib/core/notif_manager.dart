part of turbocal;

class ScopeStartDateChangeNotification extends Notification {
  final DateTime newScopeStartDate;
  const ScopeStartDateChangeNotification({
    required this.newScopeStartDate,
  });
}

class EventCardPressedNotification extends Notification {
  final TCEvent eventData;
  final RenderBox renderBox;

  EventCardPressedNotification({
    required this.eventData,
    required this.renderBox,
  });
}

class EventCardDismissedNotification extends Notification {
  const EventCardDismissedNotification();
}

class EventDataModifiedNotification extends Notification {
  const EventDataModifiedNotification();
}
