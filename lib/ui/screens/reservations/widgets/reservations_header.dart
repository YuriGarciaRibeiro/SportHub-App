import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../reservations_view_model.dart';
import 'reservation_stats_cards.dart';
import 'reservation_filter_chips.dart';

class ReservationsHeader extends StatelessWidget {
  final ReservationsViewModel viewModel;

  const ReservationsHeader({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Minhas Reservas',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          ReservationStatsCards(stats: viewModel.getReservationStats()),
          SizedBox(height: 2.h),
          ReservationFilterChips(
            selectedFilter: viewModel.selectedFilter,
            onFilterChanged: viewModel.updateFilter,
          ),
        ],
      ),
    );
  }
}
