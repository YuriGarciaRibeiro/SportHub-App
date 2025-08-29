import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../models/establishment.dart';

class OverviewTabWidget extends StatelessWidget {
  final Establishment establishment;
  const OverviewTabWidget({super.key, required this.establishment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Descrição', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Text(
            establishment.description.isNotEmpty
                ? establishment.description
                : 'Descrição não disponível.',
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),

          Text('Contato', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          _contactItem(context, Icons.phone_outlined,
              establishment.phoneNumber.isNotEmpty ? establishment.phoneNumber : 'Telefone não informado'),
          SizedBox(height: 0.8.h),
          _contactItem(context, Icons.email_outlined,
              establishment.email.isNotEmpty ? establishment.email : 'Email não informado'),
          SizedBox(height: 0.8.h),
          _contactItem(context, Icons.language_outlined,
              establishment.website.isNotEmpty ? establishment.website : 'Website não informado'),
          SizedBox(height: 2.h),

          Text('Endereço', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 1.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    establishment.address.fullAddress.isNotEmpty
                        ? establishment.address.fullAddress
                        : 'Endereço não informado',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
