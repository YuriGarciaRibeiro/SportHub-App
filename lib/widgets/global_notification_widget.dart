import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../providers/global_notification_provider.dart';

class GlobalNotificationWidget extends StatelessWidget {
  const GlobalNotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalNotificationProvider>(
      builder: (context, notificationProvider, child) {
        if (!notificationProvider.hasNotifications) {
          return const SizedBox.shrink();
        }

        final notification = notificationProvider.currentNotification!;
        
        return Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 4.w,
          right: 4.w,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: _getBackgroundColor(context, notification.type),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _getIcon(notification.type),
                    color: _getIconColor(context, notification.type),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _getTextColor(context, notification.type),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => notificationProvider.dismissCurrent(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.close,
                        color: _getIconColor(context, notification.type),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Theme.of(context).colorScheme.error;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context, NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Theme.of(context).colorScheme.onError;
      case NotificationType.success:
        return Colors.white;
      case NotificationType.warning:
        return Colors.white;
      case NotificationType.info:
        return Theme.of(context).colorScheme.onPrimary;
    }
  }

  Color _getIconColor(BuildContext context, NotificationType type) {
    return _getTextColor(context, type);
  }

  IconData _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_outlined;
      case NotificationType.info:
        return Icons.info_outline;
    }
  }
}
