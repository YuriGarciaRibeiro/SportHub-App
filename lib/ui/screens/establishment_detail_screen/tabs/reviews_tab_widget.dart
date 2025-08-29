import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ReviewsTabWidget extends StatelessWidget {
  final VoidCallback onWriteReview;
  const ReviewsTabWidget({super.key, required this.onWriteReview});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.reviews_outlined,
                color: Theme.of(context).colorScheme.onSurfaceVariant, size: 48),
            SizedBox(height: 1.5.h),
            Text('Avaliações em breve', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 1.5.h),
            OutlinedButton.icon(
              onPressed: onWriteReview,
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text('Escrever avaliação'),
            ),
          ],
        ),
      ),
    );
  }
}
