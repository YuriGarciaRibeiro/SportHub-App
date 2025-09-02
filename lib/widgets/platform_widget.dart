import 'package:flutter/material.dart';

class PlatformWidget extends StatelessWidget {
  final Widget ios;
  final Widget android;
  final Widget? fallback;

  const PlatformWidget({
    super.key,
    required this.ios,
    required this.android,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return android;
    }
  }
}
