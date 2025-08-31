import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/core/app_export.dart';

class QuickActionButton extends StatelessWidget {
  const QuickActionButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.label,
    required this.color,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            SizedBox(height: 0.8.h),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}