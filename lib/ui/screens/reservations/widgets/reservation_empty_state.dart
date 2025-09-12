import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReservationEmptyState extends StatelessWidget {
  final String filter;

  const ReservationEmptyState({
    super.key,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;
    
    switch (filter) {
      case 'upcoming':
        message = 'Nenhuma reserva próxima';
        icon = Icons.event_available;
        break;
      case 'past':
        message = 'Nenhuma reserva passada';
        icon = Icons.history;
        break;
      default:
        message = 'Nenhuma reserva encontrada';
        icon = Icons.event_note;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Que tal fazer uma nova reserva?',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
