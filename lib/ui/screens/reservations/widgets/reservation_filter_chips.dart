import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReservationFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const ReservationFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(context, 'Todas', 'all'),
          SizedBox(width: 2.w),
          _buildFilterChip(context, 'Próximas', 'upcoming'),
          SizedBox(width: 2.w),
          _buildFilterChip(context, 'Passadas', 'past'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, String value) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == value,
      onSelected: (selected) {
        if (selected) onFilterChanged(value);
      },
    );
  }
}
