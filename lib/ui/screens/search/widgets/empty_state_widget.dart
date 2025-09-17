import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmptyStateWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  
  const EmptyStateWidget({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.search_off,
            size: 64,
            color: Theme.of(context).hintColor,
          ),
          SizedBox(height: 2.h),
          Text(
            title ?? 'Nenhum estabelecimento encontrado',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            subtitle ?? 'Tente ajustar os filtros de busca',
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