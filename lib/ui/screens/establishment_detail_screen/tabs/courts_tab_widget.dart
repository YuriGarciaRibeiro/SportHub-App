import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/ui/screens/establishment_detail_screen/widgets/court_card.dart';

import '../../../../models/court.dart';

class CourtsTabWidget extends StatelessWidget {
  final List<Court> courts;
  final Function(Court) onBookCourt;

  const CourtsTabWidget({super.key, required this.courts, required this.onBookCourt});

  @override
  Widget build(BuildContext context) {
    if (courts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_tennis, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 48),
            SizedBox(height: 2.h),
            Text('Nenhuma quadra disponível',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: courts.length,
      itemBuilder: (context, index) => CourtCard(
        court: courts[index],
        onBookCourt: (court) {
          // Handle court booking
        },
      ),
    );
  }


}
