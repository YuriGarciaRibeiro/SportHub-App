import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EstablishmentsSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const EstablishmentsSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Buscar estabelecimentos...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
      ),
    );
  }
}