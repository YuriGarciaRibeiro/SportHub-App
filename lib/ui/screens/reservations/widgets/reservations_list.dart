import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../reservations_view_model.dart';
import 'reservation_card_with_actions.dart';
import 'reservation_cancel_dialog.dart';
import 'reservation_empty_state.dart';

class ReservationsList extends StatelessWidget {
  final ReservationsViewModel viewModel;

  const ReservationsList({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => viewModel.refreshReservations(),
      child: viewModel.filteredReservations.isEmpty
          ? ReservationEmptyState(filter: viewModel.selectedFilter)
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: viewModel.filteredReservations.length,
              itemBuilder: (context, index) {
                final reservation = viewModel.filteredReservations[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: ReservationCardWithActions(
                    reservation: reservation,
                    viewModel: viewModel,
                    onCancel: () => ReservationCancelDialog.show(
                      context,
                      reservation,
                      viewModel,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
