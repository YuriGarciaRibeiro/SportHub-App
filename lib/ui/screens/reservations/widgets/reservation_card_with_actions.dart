import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/models/reservation.dart';
import '../../../../../../core/app_export.dart';
import '../reservations_view_model.dart';

class ReservationCardWithActions extends StatelessWidget {
  final Reservation reservation;
  final ReservationsViewModel viewModel;
  final VoidCallback? onCancel;

  const ReservationCardWithActions({
    super.key,
    required this.reservation,
    required this.viewModel,
    this.onCancel,
  });

  

  @override
  Widget build(BuildContext context) {
    final reservationStatus = _calcReservationStatus(reservation);
    final statusColor = _getStatusColor(reservationStatus);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.establishmentName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reservation.courtName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    _getStatusLabel(reservationStatus),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 2.h),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.sp, color: Theme.of(context).hintColor),
                SizedBox(width: 2.w),
                Text(
                  '${reservation.startTime.day.toString().padLeft(2, '0')}/${reservation.startTime.month.toString().padLeft(2, '0')}/${reservation.startTime.year}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.access_time, size: 16.sp, color: Theme.of(context).hintColor),
                SizedBox(width: 2.w),
                Text(
                  '${reservation.startTime.hour.toString().padLeft(2, '0')}:${reservation.startTime.minute.toString().padLeft(2, '0')} - ${reservation.endTime.hour.toString().padLeft(2, '0')}:${reservation.endTime.minute.toString().padLeft(2, '0')}',
                  //reservation.timeSlot
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
            
            SizedBox(height: 1.h),
            
            Row(
              children: [
                Icon(Icons.attach_money, size: 16.sp, color: Theme.of(context).hintColor),
                SizedBox(width: 2.w),
                Text(
                  'R\$ ${reservation.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _calcReservationStatus(Reservation reservation) {
    final now = DateTime.now();
    if (reservation.endTime.isBefore(now)) {
      return 'past';
    } else if (reservation.startTime.isAfter(now)) {
      return 'upcoming';
    } else {
      return 'active';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'past':
        return Colors.grey;
      case 'upcoming':
        return Colors.blue;
      case 'active':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'past':
        return 'Concluída';
      case 'active':
        return 'Vigente';
      case 'upcoming':
        return 'Agendada'; 
      default:
        return 'Pendente';
    }
  }

}
