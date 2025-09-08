import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sporthub/ui/screens/establishment_detail_screen/widgets/map_card.dart';

import '../../../../models/address.dart';

class LocationTabWidget extends StatelessWidget {
  final Address address;
  final VoidCallback onGetDirections;
  const LocationTabWidget({super.key, required this.address, required this.onGetDirections});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MapCard(),
          SizedBox(height: 2.h),
          Text('Endereço', style: theme.textTheme.titleMedium),
          SizedBox(height: 0.8.h),
          Text(address.fullAddress.isNotEmpty ? address.fullAddress : 'Endereço não informado',
              style: theme.textTheme.bodyMedium),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onGetDirections,
              icon: const Icon(Icons.directions_outlined),
              label: const Text('Traçar rota'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.6.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
