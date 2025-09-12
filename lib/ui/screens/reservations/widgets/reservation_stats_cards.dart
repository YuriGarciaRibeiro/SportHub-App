import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';

class ReservationStatsCards extends StatelessWidget {
  final Map<String, int> stats;

  const ReservationStatsCards({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(context, 'Total', stats['total']!, Colors.blue)),
        SizedBox(width: 2.w),
        Expanded(child: _buildStatCard(context, 'Próximas', stats['upcoming']!, Colors.green)),
        SizedBox(width: 2.w),
        Expanded(child: _buildStatCard(context, 'Passadas', stats['past']!, Colors.orange)),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, int value, Color color) {
    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
