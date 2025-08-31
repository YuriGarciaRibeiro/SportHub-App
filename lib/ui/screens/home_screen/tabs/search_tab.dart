import 'package:sizer/sizer.dart';
import '../../../../core/app_export.dart';
import '../../../../services/establishment_service.dart';
import '../../../../models/establishment.dart';
import '../widgets/search_filters_panel_widget.dart';
import '../widgets/establishment_card_widget.dart';
import '../widgets/search_results_header_widget.dart';
import '../widgets/search_empty_state_widget.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final EstablishmentService _establishmentService = EstablishmentService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Establishment> _allEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filtros e ordenação
  SortType _currentSort = SortType.name;
  String? _selectedSport;
  double _maxDistance = 50.0;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _loadEstablishments();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  
  Future<void> _loadEstablishments() async {
    try {
      if (!mounted) return;
      
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final establishments = await _establishmentService.getAllEstablishments();
      
      if (!mounted) return;
      
      setState(() {
        _allEstablishments = establishments;
        _filteredEstablishments = establishments;
        _isLoading = false;
      });
      
      _applyFiltersAndSort();
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _errorMessage = 'Erro ao carregar estabelecimentos: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    final query = _searchController.text.toLowerCase();
    List<Establishment> filtered = _allEstablishments;

    if (query.isNotEmpty) {
      filtered = filtered.where((establishment) {
        return establishment.name.toLowerCase().contains(query) ||
               establishment.description.toLowerCase().contains(query) ||
               establishment.sports.any((sport) => 
                 sport.name.toLowerCase().contains(query));
      }).toList();
    }

    if (_selectedSport != null && _selectedSport!.isNotEmpty) {
      filtered = filtered.where((establishment) {
        return establishment.sports.any((sport) => 
          sport.name.toLowerCase() == _selectedSport!.toLowerCase());
      }).toList();
    }

    filtered = filtered.where((establishment) {
      final distance = _getEstablishmentDistance(establishment);
      return distance <= _maxDistance;
    }).toList();

    _sortEstablishments(filtered);

    setState(() {
      _filteredEstablishments = filtered;
    });
  }

  void _sortEstablishments(List<Establishment> establishments) {
    switch (_currentSort) {
      case SortType.name:
        establishments.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.rating:
        // TODO: Implementar quando tivermos sistema de avaliações
        establishments.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortType.distance:
        establishments.sort((a, b) {
          final distanceA = _getEstablishmentDistance(a);
          final distanceB = _getEstablishmentDistance(b);
          return distanceA.compareTo(distanceB);
        });
        break;
    }
  }

  List<String> _getAvailableSports() {
    final sports = <String>{};
    for (final establishment in _allEstablishments) {
      for (final sport in establishment.sports) {
        sports.add(sport.name);
      }
    }
    return sports.toList()..sort();
  }

  double _getEstablishmentDistance(Establishment establishment) {
    final hash = establishment.name.hashCode.abs();
    final distance = (hash % 95) + 1; // 1 a 95 km
    return distance.toDouble();
  }

  String _getEstablishmentPrice(Establishment establishment) {
    final hash = establishment.name.hashCode.abs();
    final basePrice = (hash % 80) + 20; // 20 a 99 reais
    return 'A partir de R\$ $basePrice/h';
  }

  
  void _onSportChanged(String? sport) {
    setState(() {
      _selectedSport = sport;
    });
    _applyFiltersAndSort();
  }

  void _onSortChanged(SortType sort) {
    setState(() {
      _currentSort = sort;
    });
    _applyFiltersAndSort();
  }

  void _onDistanceChanged(double distance) {
    setState(() {
      _maxDistance = distance;
    });
    _applyFiltersAndSort();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedSport = null;
    });
    _applyFiltersAndSort();
  }

  bool _hasActiveFilters() {
    return _searchController.text.isNotEmpty || _selectedSport != null;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          _buildSearchBar(),
          if (_showFilters) ...[
            SizedBox(height: 2.h),
            _buildFiltersPanel(),
          ],
          SizedBox(height: 3.h),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar estabelecimentos...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _buildFiltersPanel() {
    return SearchFiltersPanelWidget(
      selectedSport: _selectedSport,
      currentSort: _currentSort,
      maxDistance: _maxDistance,
      availableSports: _getAvailableSports(),
      onSportChanged: _onSportChanged,
      onSortChanged: _onSortChanged,
      onDistanceChanged: _onDistanceChanged,
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const SearchEmptyStateWidget(type: SearchEmptyStateType.loading);
    }

    if (_errorMessage != null) {
      return SearchEmptyStateWidget(
        type: SearchEmptyStateType.error,
        errorMessage: _errorMessage,
        onRetry: _loadEstablishments,
      );
    }

    if (_filteredEstablishments.isEmpty) {
      if (_hasActiveFilters()) {
        return SearchEmptyStateWidget(
          type: SearchEmptyStateType.noResultsWithFilters,
          onClearFilters: _clearFilters,
        );
      } else {
        return const SearchEmptyStateWidget(type: SearchEmptyStateType.noResults);
      }
    }

    return _buildEstablishmentsList();
  }

  Widget _buildEstablishmentsList() {
    return Column(
      children: [
        SearchResultsHeaderWidget(
          resultsCount: _filteredEstablishments.length,
          hasActiveFilters: _hasActiveFilters(),
          onClearFilters: _clearFilters,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredEstablishments.length,
            itemBuilder: (context, index) {
              final establishment = _filteredEstablishments[index];
              return EstablishmentCardWidget(
                establishment: establishment,
                getEstablishmentDistance: _getEstablishmentDistance,
                getEstablishmentPrice: _getEstablishmentPrice,
              );
            },
          ),
        ),
      ],
    );
  }
}
