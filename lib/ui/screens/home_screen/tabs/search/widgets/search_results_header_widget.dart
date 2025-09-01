import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchResultsHeaderWidget extends StatelessWidget {
  final int resultsCount;
  final bool hasActiveFilters;
  final VoidCallback onClearFilters;

  const SearchResultsHeaderWidget({
    super.key,
    required this.resultsCount,
    required this.hasActiveFilters,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Text(
            '$resultsCount estabelecimento${resultsCount != 1 ? 's' : ''} encontrado${resultsCount != 1 ? 's' : ''}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const Spacer(),
          if (hasActiveFilters)
            TextButton.icon(
              onPressed: onClearFilters,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Limpar filtros'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
