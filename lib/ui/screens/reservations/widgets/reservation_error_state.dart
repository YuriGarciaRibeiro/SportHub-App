import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReservationErrorState extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const ReservationErrorState({
    super.key,
    this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: 2.h),
          Text(
            'Erro ao carregar reservas',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            errorMessage ?? 'Erro desconhecido',
            style: TextStyle(
              fontSize: 12.sp,
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
