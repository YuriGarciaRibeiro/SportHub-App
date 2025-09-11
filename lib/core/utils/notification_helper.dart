import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/global_notification_provider.dart';

class NotificationHelper {
  static void showError(BuildContext context, String message, {int? durationSeconds}) {
    final provider = Provider.of<GlobalNotificationProvider>(context, listen: false);
    provider.showError(message, durationSeconds: durationSeconds);
  }

  static void showSuccess(BuildContext context, String message, {int? durationSeconds}) {
    final provider = Provider.of<GlobalNotificationProvider>(context, listen: false);
    provider.showSuccess(message, durationSeconds: durationSeconds);
  }

  static void showWarning(BuildContext context, String message, {int? durationSeconds}) {
    final provider = Provider.of<GlobalNotificationProvider>(context, listen: false);
    provider.showWarning(message, durationSeconds: durationSeconds);
  }

  static void showInfo(BuildContext context, String message, {int? durationSeconds}) {
    final provider = Provider.of<GlobalNotificationProvider>(context, listen: false);
    provider.showInfo(message, durationSeconds: durationSeconds);
  }

  static void dismissAll(BuildContext context) {
    final provider = Provider.of<GlobalNotificationProvider>(context, listen: false);
    provider.dismissAll();
  }
}
