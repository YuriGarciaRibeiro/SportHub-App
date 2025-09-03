import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../../models/establishment.dart';
import '../../../../../../../widgets/platform_widget.dart';
import 'establishment_list_item.dart';

class SearchModal extends StatefulWidget {
  final List<Establishment> allEstablishments;
  final Function(Establishment) onEstablishmentSelected;

  const SearchModal({
    super.key,
    required this.allEstablishments,
    required this.onEstablishmentSelected,
  });

  @override
  State<SearchModal> createState() => _SearchModalState();
}

class _SearchModalState extends State<SearchModal> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Establishment> _filterEstablishments(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return widget.allEstablishments.where((e) {
      return e.name.toLowerCase().contains(q) ||
          e.description.toLowerCase().contains(q) ||
          e.sports.any((s) => s.name.toLowerCase().contains(q));
    }).take(20).toList();
  }

  void _onSearchSubmitted() {
    _focusNode.unfocus();
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: PlatformWidget(
        android: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Buscar estabelecimentos...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _searchController.clear,
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
          ),
          onSubmitted: (_) => _onSearchSubmitted(),
        ),
        ios: CupertinoSearchTextField(
          controller: _searchController,
          focusNode: _focusNode,
          placeholder: 'Buscar estabelecimentos...',
          onSubmitted: (_) => _onSearchSubmitted(),
          onSuffixTap: _searchController.clear,
        ),
      ),
    );
  }

  Widget _buildResultsList(List<Establishment> results, ScrollController? scrollController) {
    return PlatformWidget(
      android: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final e = results[index];
          return EstablishmentListItem(
            establishment: e,
            onTap: () => widget.onEstablishmentSelected(e),
          );
        },
      ),
      ios: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: results.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        itemBuilder: (context, index) {
          final e = results[index];
          return EstablishmentListItem(
            establishment: e,
            onTap: () => widget.onEstablishmentSelected(e),
            isIOSStyle: true,
          );
        },
      ),
    );
  }

  Widget _emptyContent(IconData icon, String message) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: cs.onSurface.withOpacity(0.4)),
          SizedBox(height: 2.h),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: cs.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateInitial() {
    return PlatformWidget(
      android: _emptyContent(Icons.search, 'Digite para buscar estabelecimentos'),
      ios: _emptyContent(CupertinoIcons.search, 'Digite para buscar estabelecimentos'),
    );
  }

  Widget _buildEmptyStateNoResults() {
    return PlatformWidget(
      android: _emptyContent(Icons.search_off, 'Nenhum estabelecimento encontrado'),
      ios: _emptyContent(CupertinoIcons.search_circle, 'Nenhum estabelecimento encontrado'),
    );
  }

  Widget _buildContent(ScrollController? scrollController) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: cs.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          _buildSearchField(cs),
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                final query = value.text;
                if (query.isEmpty) return _buildEmptyStateInitial();

                final results = _filterEstablishments(query);
                if (results.isEmpty) return _buildEmptyStateNoResults();

                return _buildResultsList(results, scrollController);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      android: DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => _buildContent(scrollController),
      ),
      ios: FractionallySizedBox(
        heightFactor: 0.9,
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          child: _buildContent(ScrollController()),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
