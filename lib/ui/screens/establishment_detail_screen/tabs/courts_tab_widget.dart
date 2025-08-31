import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
      itemBuilder: (context, index) => _courtCard(context, courts[index]),
    );
  }

  Widget _courtCard(BuildContext context, Court court) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    court.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    court.sports.isNotEmpty ? court.sports.first.name : 'Geral',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Funcionamento: ${court.workingHours}', style: Theme.of(context).textTheme.bodySmall),
                Text(
                  court.pricePerSlot != null ? 'R\$ ${(court.pricePerSlot as num).toStringAsFixed(2)}' : 'Consultar valor',
                  style: Theme.of(context).textTheme.bodySmall
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => onBookCourt(court),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 1.8.h),
                ),
                child: const Text('Reservar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
