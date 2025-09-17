import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../search_view_model.dart';
import 'sport_filter_widget.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final SearchViewModel viewModel;
  final VoidCallback onClearSearch;
  
  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.viewModel,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Buscar estabelecimentos...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: onClearSearch,
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) => viewModel.updateSearchQuery(value),
          ),
          
          SizedBox(height: 2.h),
          
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SportFilterWidget(viewModel: viewModel),
                SizedBox(width: 2.w),
                
                FilterChip(
                  label: const Text('Abertos agora'),
                  selected: viewModel.isOpen,
                  onSelected: (selected) => viewModel.updateOpenFilter(selected),
                ),
                SizedBox(width: 2.w),
                
                if (viewModel.searchQuery.isNotEmpty || 
                    viewModel.selectedSport != null || 
                    viewModel.isOpen)
                  ActionChip(
                    label: const Text('Limpar'),
                    onPressed: () {
                      searchController.clear();
                      viewModel.clearFilters();
                    },
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${viewModel.filteredEstablishments.length} estabelecimentos',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).hintColor,
                ),
              ),
              DropdownButton<String>(
                value: viewModel.sortBy,
                underline: Container(),
                items: const [
                  DropdownMenuItem(value: 'distance', child: Text('Distância')),
                  DropdownMenuItem(value: 'rating', child: Text('Avaliação')),
                  DropdownMenuItem(value: 'name', child: Text('Nome')),
                ],
                onChanged: (value) {
                  if (value != null) viewModel.updateSortBy(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}