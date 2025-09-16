import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EstablishmentsLoadingState extends StatelessWidget {
  final String message;

  const EstablishmentsLoadingState({
    super.key,
    this.message = 'Carregando estabelecimentos...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}