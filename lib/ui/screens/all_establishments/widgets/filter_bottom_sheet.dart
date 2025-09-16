import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../all_establishments_view_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final AllEstablishmentsViewModel viewModel;
  final TextEditingController searchController;

  const FilterBottomSheet({
    super.key,
    required this.viewModel,
    required this.searchController,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  bool _showOnlyOpen = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filtros',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: const Text('Apenas abertos agora'),
            trailing: Switch(
              value: _showOnlyOpen,
              onChanged: (value) {
                setState(() {
                  _showOnlyOpen = value;
                });
                if (value) {
                  widget.viewModel.filterOpenEstablishments();
                } else {
                  widget.viewModel.clearOpenFilter();
                }
                Navigator.pop(context);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Apenas favoritos'),
            onTap: () {
              widget.viewModel.toggleFavoritesFilter();
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.viewModel.clearSearch();
                    widget.searchController.clear();
                    setState(() {
                      _showOnlyOpen = false;
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Limpar Filtros'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}