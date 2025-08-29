import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'home_outlined':
        return Icons.home_outlined;
      case 'search':
        return Icons.search;
      case 'event':
        return Icons.event;
      case 'event_outlined':
        return Icons.event_outlined;
      case 'person':
        return Icons.person;
      case 'person_outline':
        return Icons.person_outline;
      case 'add':
        return Icons.add;
      case 'location_on':
        return Icons.location_on;
      case 'star':
        return Icons.star;
      case 'access_time':
        return Icons.access_time;
      case 'arrow_forward':
        return Icons.arrow_forward;
      case 'sports':
        return Icons.sports;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'sports_tennis':
        return Icons.sports_tennis;
      case 'sports_basketball':
        return Icons.sports_basketball;
      case 'sports_volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(iconName),
      color: color,
      size: size,
    );
  }
}
