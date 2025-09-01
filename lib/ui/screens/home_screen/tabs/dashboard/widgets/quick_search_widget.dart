import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../../../core/app_export.dart';
import '../../../../../../services/establishment_service.dart';
import '../../../../../../models/establishment.dart';
import '../../../../establishment_detail_screen/establishment_detail_screen.dart';

class QuickSearchWidget extends StatefulWidget {
  const QuickSearchWidget({super.key});

  @override
  State<QuickSearchWidget> createState() => _QuickSearchWidgetState();
}

class _QuickSearchWidgetState extends State<QuickSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final EstablishmentService _establishmentService = EstablishmentService();
  final FocusNode _focusNode = FocusNode();

  List<Establishment> _allEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _loadEstablishments() async {
    try {
      if (!mounted) return;
      
      setState(() => _isLoading = true);
      final establishments = await _establishmentService.getAllEstablishments();
      
      if (!mounted) return;
      
      setState(() {
        _allEstablishments = establishments;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      debugPrint('Erro ao carregar estabelecimentos: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredEstablishments = [];
        _showSuggestions = false;
      });
      return;
    }

    final filtered = _allEstablishments.where((establishment) {
      return establishment.name.toLowerCase().contains(query) ||
             establishment.description.toLowerCase().contains(query) ||
             establishment.sports.any((sport) =>
               sport.name.toLowerCase().contains(query));
    }).take(5).toList(); // Limitar a 5 sugestões

    setState(() {
      _filteredEstablishments = filtered;
      _showSuggestions = true;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  void _onEstablishmentSelected(Establishment establishment) {
    _searchController.clear();
    _focusNode.unfocus();
    setState(() => _showSuggestions = false);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EstablishmentDetailScreen(
          establishment: establishment,
        ),
      ),
    );
  }

  void _onSearchSubmitted() {
    if (_searchController.text.isNotEmpty) {
      _showSearchModal();
    }
  }

  void _showSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(4.w),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Buscar estabelecimentos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _showSuggestions = false);
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  onSubmitted: (_) => _onSearchSubmitted(),
                ),
              ),
              Expanded(
                child: _buildSearchResults(scrollController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(ScrollController scrollController) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              'Digite para buscar estabelecimentos',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_filteredEstablishments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
            SizedBox(height: 2.h),
            Text(
              'Nenhum estabelecimento encontrado',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: _filteredEstablishments.length,
      itemBuilder: (context, index) {
        final establishment = _filteredEstablishments[index];
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(3.w),
            leading: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: establishment.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.network(
                        establishment.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.business),
                      ),
                    )
                  : const Icon(Icons.business),
            ),
            title: Text(
              establishment.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.5.h),
                Text(
                  establishment.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (establishment.sports.isNotEmpty) ...[
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 1.w,
                    children: establishment.sports.take(2).map((sport) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          sport.name,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
            onTap: () => _onEstablishmentSelected(establishment),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showSearchModal,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Buscar estabelecimentos...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (_showSuggestions && _filteredEstablishments.isNotEmpty)
            Container(
              margin: EdgeInsets.only(top: 1.h),
              constraints: BoxConstraints(maxHeight: 40.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredEstablishments.length,
                itemBuilder: (context, index) {
                  final establishment = _filteredEstablishments[index];
                  return ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(establishment.name),
                    subtitle: Text(
                      establishment.sports.isNotEmpty
                          ? establishment.sports.first.name
                          : establishment.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _onEstablishmentSelected(establishment),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
