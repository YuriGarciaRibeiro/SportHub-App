import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../models/establishment.dart';
import 'establishment_card_widget.dart';

class EstablishmentListWidget extends StatelessWidget {
  final List<Establishment> establishments;
  final Future<void> Function() onRefresh;
  
  const EstablishmentListWidget({
    super.key,
    required this.establishments,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: establishments.length,
        itemBuilder: (context, index) {
          final establishment = establishments[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: EstablishmentCardWidget(
              establishment: establishment
            ),
          );
        },
      ),
    );
  }
}