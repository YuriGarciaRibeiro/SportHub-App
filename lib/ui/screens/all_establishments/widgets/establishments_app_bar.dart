import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../all_establishments_view_model.dart';

class EstablishmentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AllEstablishmentsViewModel viewModel;
  final VoidCallback onFilterPressed;

  const EstablishmentsAppBar({
    super.key,
    required this.title,
    required this.viewModel,
    required this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort),
          onSelected: (value) {
            viewModel.updateSortBy(value);
          },
          itemBuilder: (context) => viewModel.sortOptions
              .map((option) => PopupMenuItem<String>(
                    value: option['value'],
                    child: Row(
                      children: [
                        Icon(
                          viewModel.sortBy == option['value'] 
                              ? Icons.check 
                              : Icons.check_box_outline_blank,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Text(option['label']!),
                      ],
                    ),
                  ))
              .toList(),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: onFilterPressed,
        ),
      ],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}