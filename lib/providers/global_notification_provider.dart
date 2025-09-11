import 'package:flutter/material.dart';

enum NotificationType {
  error,
  success,
  warning,
  info,
}

class GlobalNotification {
  final String id;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final int? durationSeconds;

  GlobalNotification({
    required this.message,
    required this.type,
    this.durationSeconds = 5,
  })  : id = DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = DateTime.now();
}

class GlobalNotificationProvider extends ChangeNotifier {
  final List<GlobalNotification> _notifications = [];

  List<GlobalNotification> get notifications => List.unmodifiable(_notifications);
  
  bool get hasNotifications => _notifications.isNotEmpty;
  
  GlobalNotification? get currentNotification => 
      _notifications.isNotEmpty ? _notifications.first : null;

  void showError(String message, {int? durationSeconds}) {
    _addNotification(GlobalNotification(
      message: message,
      type: NotificationType.error,
      durationSeconds: durationSeconds ?? 5,
    ));
  }

  void showSuccess(String message, {int? durationSeconds}) {
    _addNotification(GlobalNotification(
      message: message,
      type: NotificationType.success,
      durationSeconds: durationSeconds ?? 5,
    ));
  }

  void showWarning(String message, {int? durationSeconds}) {
    _addNotification(GlobalNotification(
      message: message,
      type: NotificationType.warning,
      durationSeconds: durationSeconds ?? 5,
    ));
  }

  void showInfo(String message, {int? durationSeconds}) {
    _addNotification(GlobalNotification(
      message: message,
      type: NotificationType.info,
      durationSeconds: durationSeconds ?? 5,
    ));
  }

  void _addNotification(GlobalNotification notification) {
    _notifications.add(notification);
    notifyListeners();

    // Auto-dismiss após o tempo especificado
    if (notification.durationSeconds != null) {
      Future.delayed(Duration(seconds: notification.durationSeconds!), () {
        dismissNotification(notification.id);
      });
    }
  }

  void dismissNotification(String id) {
    _notifications.removeWhere((notification) => notification.id == id);
    notifyListeners();
  }

  void dismissCurrent() {
    if (_notifications.isNotEmpty) {
      _notifications.removeAt(0);
      notifyListeners();
    }
  }

  void dismissAll() {
    _notifications.clear();
    notifyListeners();
  }
}
