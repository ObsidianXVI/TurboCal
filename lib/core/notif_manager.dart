part of turbocal;

abstract class NotificationChannel<T extends Notification> {
  final Type payloadType = T;
  final List<void Function(Notification)> handlers;

  NotificationChannel({
    required this.handlers,
  });
}

class TurbocalNotification extends Notification {
  final List<Notification> notifications;

  const TurbocalNotification({
    required this.notifications,
  });
}

class NotificationManager extends NotificationListener<TurbocalNotification> {
  final List<NotificationChannel> channels;

  NotificationManager({
    required super.child,
    required this.channels,
    super.key,
  }) : super(
          onNotification: (TurbocalNotification tcNotif) {
            for (Notification notif in tcNotif.notifications) {
              final Iterable<NotificationChannel<Notification>> channel =
                  channels.where((NotificationChannel nc) =>
                      nc.payloadType == notif.runtimeType);
              if (channel.isNotEmpty) {
                for (void Function(Notification) handler
                    in channel.first.handlers) {
                  handler(notif);
                }
              }
            }
            return true;
          },
        );
}

class ScopeStartDateChangeChannel
    extends NotificationChannel<ScopeStartDateChangeNotification> {
  ScopeStartDateChangeChannel({
    required super.handlers,
  });
}

class ScopeStartDateChangeNotification extends Notification {
  final DateTime newScopeStartDate;
  const ScopeStartDateChangeNotification({
    required this.newScopeStartDate,
  });
}
