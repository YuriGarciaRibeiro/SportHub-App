import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EstablishmentsEmptyState extends StatelessWidget {
  final String searchQuery;
  final VoidCallback? onClearSearch;

  const EstablishmentsEmptyState({
    super.key,
    required this.searchQuery,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 15.w,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              searchQuery.isEmpty
                  ? 'Nenhum estabelecimento disponível'
                  : 'Nenhum resultado encontrado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              searchQuery.isEmpty
                  ? 'Não há estabelecimentos cadastrados no momento.'
                  : 'Tente buscar com outros termos.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.isNotEmpty && onClearSearch != null) ...[
              SizedBox(height: 3.h),
              ElevatedButton(
                onPressed: onClearSearch,
                child: const Text('Limpar busca'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}