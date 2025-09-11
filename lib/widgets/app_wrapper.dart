import 'package:flutter/material.dart';
import '../widgets/global_notification_widget.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const GlobalNotificationWidget(),
      ],
    );
  }
}
