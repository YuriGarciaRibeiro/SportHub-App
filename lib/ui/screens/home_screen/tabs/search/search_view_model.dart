import 'package:flutter/foundation.dart';
import '../../../../../models/establishment.dart';
import '../../../../../models/sport.dart';
import '../../../../../services/establishment_service.dart';
import '../../../../../services/sports_service.dart';
import '../../../../../core/base_view_model.dart';

class SearchViewModel extends BaseViewModel {
  final EstablishmentService _establishmentService = EstablishmentService();
  final SportsService _sportsService = SportsService();

  List<Establishment> _allEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  List<Sport> _availableSports = [];
  String _searchQuery = '';
  Sport? _selectedSport;
  double _maxDistance = 50.0;
  bool _isOpen = false;
  String _sortBy = 'distance';
  bool _isInitialized = false;

  List<Establishment> get filteredEstablishments => _filteredEstablishments;
  List<Sport> get availableSports => _availableSports;
  String get searchQuery => _searchQuery;
  Sport? get selectedSport => _selectedSport;
  double get maxDistance => _maxDistance;
  bool get isOpen => _isOpen;
  String get sortBy => _sortBy;

  Future<void> initializeSearch() async {
    // Se já foi inicializado e temos dados, não precisa recarregar
    if (_isInitialized && _allEstablishments.isNotEmpty) {
      return;
    }

    // Se não tem dados ainda, carrega com loading
    if (_allEstablishments.isEmpty) {
      await executeOperation(() async {
        await Future.wait([
          _loadAllEstablishments(),
          _loadAvailableSports(),
        ]);
        _applyFilters();
        _isInitialized = true;
      });
    } else {
      // Se já tem dados, só atualiza sem loading
      await Future.wait([
        _loadAllEstablishments(),
        _loadAvailableSports(),
      ]);
      _applyFilters();
      _isInitialized = true;
    }
  }

  Future<void> _loadAllEstablishments() async {
    try {
      _allEstablishments = await _establishmentService.getAllEstablishments();
    } catch (e) {
      _allEstablishments = [];
    }
    notifyListeners();
  }

  /// Carrega todos os esportes disponíveis
  Future<void> _loadAvailableSports() async {
    try {
      _availableSports = await _sportsService.getAllSports();
    } catch (e) {
      _availableSports = [];
    }
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void updateSportFilter(Sport? sport) {
    _selectedSport = sport;
    _applyFilters();
    notifyListeners();
  }

  void updateMaxDistance(double distance) {
    _maxDistance = distance;
    _applyFilters();
    notifyListeners();
  }

  void updateOpenFilter(bool isOpen) {
    _isOpen = isOpen;
    _applyFilters();
    notifyListeners();
  }

  void updateSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<Establishment> filtered = List.from(_allEstablishments);

    // Filtro por busca de texto
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((establishment) {
        return establishment.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               establishment.address.fullAddress.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Filtro por esporte
    if (_selectedSport != null) {
      filtered = filtered.where((establishment) {
        return establishment.sports.any((sport) => sport.id == _selectedSport!.id);
      }).toList();
    }

    // Filtro por estabelecimentos abertos (simulado)
    if (_isOpen) {
      filtered = filtered.where((establishment) {
        return (establishment.startingPrice ?? 0) < 50;
      }).toList();
    }

    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => (b.startingPrice ?? 0).compareTo(a.startingPrice ?? 0));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'distance':
      default:
        filtered.shuffle();
        break;
    }

    _filteredEstablishments = filtered;
  }

  /// Limpa todos os filtros
  void clearFilters() {
    _searchQuery = '';
    _selectedSport = null;
    _maxDistance = 50.0;
    _isOpen = false;
    _sortBy = 'distance';
    _applyFilters();
    notifyListeners();
  }

  Future<void> refreshSearch() async {
    _isInitialized = false; // Força a reinicialização
    await initializeSearch();
  }

  void navigateToEstablishment(Establishment establishment) {
    debugPrint('Navegando para estabelecimento: ${establishment.name}');
  }

  Future<void> searchBySport(String sportId) async {
    await executeOperation(() async {
      try {
        final establishments = await _establishmentService.getEstablishmentsBySport(sportId);
        _filteredEstablishments = establishments;
      } catch (e) {
        _filteredEstablishments = [];
      }
    });
  }
}
