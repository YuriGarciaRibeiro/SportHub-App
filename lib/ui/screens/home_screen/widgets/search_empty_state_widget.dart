import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SearchEmptyStateWidget extends StatelessWidget {
  final SearchEmptyStateType type;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final VoidCallback? onClearFilters;

  const SearchEmptyStateWidget({
    super.key,
    required this.type,
    this.errorMessage,
    this.onRetry,
    this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SearchEmptyStateType.loading:
        return const Center(child: CircularProgressIndicator());
        
      case SearchEmptyStateType.error:
        return _buildErrorState(context);
        
      case SearchEmptyStateType.noResults:
        return _buildNoResultsState(context);
        
      case SearchEmptyStateType.noResultsWithFilters:
        return _buildNoResultsWithFiltersState(context);
    }
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          SizedBox(height: 2.h),
          Text(
            errorMessage ?? 'Erro ao carregar estabelecimentos',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          if (onRetry != null)
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          SizedBox(height: 2.h),
          Text(
            'Nenhum estabelecimento disponível',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWithFiltersState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          ),
          SizedBox(height: 2.h),
          Text(
            'Nenhum estabelecimento encontrado com os filtros aplicados',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          if (onClearFilters != null)
            ElevatedButton(
              onPressed: onClearFilters,
              child: const Text('Limpar filtros'),
            ),
        ],
      ),
    );
  }
}

enum SearchEmptyStateType {
  loading,
  error,
  noResults,
  noResultsWithFilters,
}
