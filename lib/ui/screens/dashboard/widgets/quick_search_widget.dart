import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../../../../models/establishment.dart';
import '../../establishment_detail_screen/establishment_detail_screen.dart';
import 'search/search_controller.dart';
import 'search/search_modal.dart';
import 'search/search_suggestions.dart';

class QuickSearchWidget extends StatefulWidget {
  const QuickSearchWidget({super.key});

  @override
  State<QuickSearchWidget> createState() => _QuickSearchWidgetState();
}

class _QuickSearchWidgetState extends State<QuickSearchWidget> {
  final EstablishmentSearchController _searchController = EstablishmentSearchController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.loadEstablishments();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (!mounted || _searchController.disposed) return;
    _searchController.updateSearchQuery(_textController.text);
    if (mounted) {
      setState(() {
        _showSuggestions = _textController.text.isNotEmpty && _focusNode.hasFocus;
      });
    }
  }

  void _onFocusChanged() {
    if (!mounted) return;
    setState(() {
      _showSuggestions = _textController.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _onEstablishmentSelected(Establishment establishment) {
    if (!mounted) return;

    _textController.clear();
    _focusNode.unfocus();
    if (!_searchController.disposed) {
      _searchController.clearSearch();
    }

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final route = isIOS
        ? CupertinoPageRoute(
            builder: (_) => EstablishmentDetailScreen(establishment: establishment),
          )
        : MaterialPageRoute(
            builder: (_) => EstablishmentDetailScreen(establishment: establishment),
          );

    Navigator.of(context).push(route);
  }

  Future<void> _showSearchModal() async {
    if (!mounted) return;

    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (_) => SearchModal(
          allEstablishments: _searchController.allEstablishments,
          onEstablishmentSelected: (e) {
            Navigator.of(context).pop();
            Future.microtask(() {
              if (mounted) _onEstablishmentSelected(e);
            });
          },
        ),
      );
    } else {
      await showModalBottomSheet(
        context: context,
        useRootNavigator: false, 
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SearchModal(
          allEstablishments: _searchController.allEstablishments,
          onEstablishmentSelected: (e) {
            Navigator.of(context).pop();
            Future.microtask(() {
              if (mounted) _onEstablishmentSelected(e);
            });
          },
        ),
      );
    }
  }

  Widget _buildSearchButton() {
    final colorScheme = Theme.of(context).colorScheme;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return GestureDetector(
      onTap: _showSearchModal,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(isIOS ? 0.2 : 0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isIOS ? CupertinoIcons.search : Icons.search,
              color: colorScheme.onSurface.withOpacity(0.6),
              size: 20,
            ),
            SizedBox(width: 3.w),
            Text(
              'Buscar estabelecimentos...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
            const Spacer(),
            Icon(
              isIOS ? CupertinoIcons.chevron_right : Icons.arrow_forward_ios,
              color: colorScheme.onSurface.withOpacity(0.4),
              size: isIOS ? 18 : 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildSearchButton(),
          ListenableBuilder(
            listenable: _searchController,
            builder: (context, _) {
              if (!_showSuggestions || _searchController.disposed) {
                return const SizedBox.shrink();
              }
              final suggestions = _searchController.filteredEstablishments.take(5).toList();
              return SearchSuggestions(
                suggestions: suggestions,
                onEstablishmentSelected: _onEstablishmentSelected,
              );
            },
          ),
        ],
      ),
    );
  }
}
