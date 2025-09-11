import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
    final isUpcoming = reservation.date.isAfter(DateTime.now());
    final statusColor = _getStatusColor(reservation.status);
    
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
                    _getStatusLabel(reservation.status),
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
                  '${reservation.date.day.toString().padLeft(2, '0')}/${reservation.date.month.toString().padLeft(2, '0')}/${reservation.date.year}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.access_time, size: 16.sp, color: Theme.of(context).hintColor),
                SizedBox(width: 2.w),
                Text(
                  reservation.timeSlot,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
            
            SizedBox(height: 1.h),
            
            Row(
              children: [
                Icon(Icons.sports, size: 16.sp, color: Theme.of(context).hintColor),
                SizedBox(width: 2.w),
                Text(
                  reservation.sport,
                  style: TextStyle(fontSize: 12.sp),
                ),
                const Spacer(),
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
            
            if (isUpcoming && reservation.status != 'cancelled') ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  if (reservation.status == 'pending')
                    Expanded(
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading 
                            ? null 
                            : () => viewModel.confirmReservation(reservation.id),
                        child: const Text('Confirmar'),
                      ),
                    ),
                  if (reservation.status == 'pending') SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: viewModel.isLoading 
                          ? null 
                          : onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmada';
      case 'pending':
        return 'Pendente';
      case 'cancelled':
        return 'Cancelada';
      default:
        return 'Desconhecido';
    }
  }
}
