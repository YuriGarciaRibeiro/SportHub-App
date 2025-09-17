import 'package:flutter/foundation.dart';
import 'package:sporthub/services/location_weather_service.dart';
import '../../../../../models/establishment.dart';
import '../../../../../models/sport.dart';
import '../../../../../services/establishment_service.dart';
import '../../../../../services/sports_service.dart';
import '../../../../../core/base_view_model.dart';

class SearchViewModel extends BaseViewModel {
  final EstablishmentService _establishmentService = EstablishmentService();
  final SportsService _sportsService = SportsService();
  final LocationWeatherService _locationWeatherService = LocationWeatherService();

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

  Future<void> initializeWithParameters(Map<String, String?> queryParams) async {
    // Carregar dados primeiro se necessário
    if (_allEstablishments.isEmpty || _availableSports.isEmpty) {
      await executeOperation(() async {
        await Future.wait([
          _loadAllEstablishments(),
          _loadAvailableSports(),
        ]);
      });
    }
    
    if (queryParams['sport'] != null && queryParams['sport']!.isNotEmpty) {
      final sportName = queryParams['sport']!;
      final sport = _availableSports.where((s) => 
        s.name.toLowerCase() == sportName.toLowerCase()
      ).firstOrNull;
      if (sport != null) {
        _selectedSport = sport;
      }
    }
    
    if (queryParams['query'] != null && queryParams['query']!.isNotEmpty) {
      _searchQuery = queryParams['query']!;
    }
    
    if (queryParams['open'] == 'true') {
      _isOpen = true;
    }
    

    if (queryParams['sortBy'] != null) {
      final sortBy = queryParams['sortBy']!;
      if (['distance', 'rating', 'name'].contains(sortBy)) {
        _sortBy = sortBy;
      }
    }
    
    if (queryParams['maxDistance'] != null) {
      final distance = double.tryParse(queryParams['maxDistance']!);
      if (distance != null && distance > 0) {
        _maxDistance = distance;
      }
    }
    
    _applyFilters();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadAllEstablishments() async {
    var position = await _locationWeatherService.getCurrentPosition();

    try {
      debugPrint('Carregando todos os estabelecimentos...');
      _allEstablishments = await _establishmentService.getAllEstablishments(
        position!.latitude,
        position.longitude,
        50.0,
        1, 500,
      );
    } catch (e) {
      debugPrint('Erro ao carregar estabelecimentos: $e');
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
    // TODO: 49 [Facilidade: 3, Prioridade: 4] - Implementar filtro por distância usando GPS
    // TODO: 50 [Facilidade: 4, Prioridade: 3] - Adicionar filtro por faixa de preço
    // TODO: 51 [Facilidade: 3, Prioridade: 3] - Implementar filtro por avaliação mínima
    // TODO: 52 [Facilidade: 2, Prioridade: 2] - Adicionar filtro por horário de funcionamento
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
        return establishment.isOpen() ? true : false;
      }).toList();
    }

    switch (_sortBy) {
      case 'rating':
        filtered.sort((a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'distance':
      default:
        // Ordena por distância se disponível, senão por nome para manter consistência
        filtered.sort((a, b) {
          final distanceA = a.distanceKm ?? double.maxFinite;
          final distanceB = b.distanceKm ?? double.maxFinite;
          
          // Se ambos têm distância, ordena por distância
          if (distanceA != double.maxFinite && distanceB != double.maxFinite) {
            return distanceA.compareTo(distanceB);
          }
          
          // Se apenas um tem distância, ele vem primeiro
          if (distanceA != double.maxFinite) return -1;
          if (distanceB != double.maxFinite) return 1;
          
          // Se nenhum tem distância, ordena por nome para manter consistência
          return a.name.compareTo(b.name);
        });
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
