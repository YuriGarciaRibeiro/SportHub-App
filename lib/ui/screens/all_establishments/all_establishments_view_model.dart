import 'package:sporthub/models/establishment.dart';
import 'package:sporthub/core/base_view_model.dart';
import 'package:sporthub/services/establishment_service.dart';
import 'package:flutter/material.dart';
import 'package:sporthub/services/location_weather_service.dart';

class AllEstablishmentsViewModel extends BaseViewModel {
  final EstablishmentService _establishmentService = EstablishmentService();
  final LocationWeatherService _locationWeatherService = LocationWeatherService();

  List<Establishment> _originalEstablishments = [];
  List<Establishment> _filteredEstablishments = [];
  String _searchQuery = '';
  String _sortBy = 'name'; // name, distance, rating

  List<Establishment> get filteredEstablishments => _filteredEstablishments;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get hasEstablishments => _filteredEstablishments.isNotEmpty;

  /// Inicializa com a lista de estabelecimentos
  void initializeWithEstablishments(List<Establishment> establishments) {
    _originalEstablishments = establishments;
    _filteredEstablishments = List.from(establishments);
    _sortEstablishments();
    notifyListeners();
  }

  /// Atualiza a query de busca e aplica filtros
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Limpa a busca
  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
  }

  /// Atualiza o tipo de ordenação
  void updateSortBy(String sortBy) {
    _sortBy = sortBy;
    _sortEstablishments();
    notifyListeners();
  }

  /// Aplica filtros baseados na query de busca
  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredEstablishments = List.from(_originalEstablishments);
    } else {
      _filteredEstablishments = _originalEstablishments.where((establishment) {
        final searchLower = _searchQuery.toLowerCase();
        
        return establishment.name.toLowerCase().contains(searchLower) ||
               establishment.description.toLowerCase().contains(searchLower) ||
               establishment.address.street.toLowerCase().contains(searchLower) ||
               establishment.address.city.toLowerCase().contains(searchLower) ||
               (establishment.address.neighborhood?.toLowerCase().contains(searchLower) ?? false) ||
               establishment.sports.any((sport) => 
                 sport.name.toLowerCase().contains(searchLower));
      }).toList();
    }
    
    _sortEstablishments();
    notifyListeners();
  }

  /// Ordena os estabelecimentos baseado no critério selecionado
  void _sortEstablishments() {
    switch (_sortBy) {
      case 'name':
        _filteredEstablishments.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'distance':
        _filteredEstablishments.sort((a, b) {
          final aDistance = a.distanceKm ?? double.infinity;
          final bDistance = b.distanceKm ?? double.infinity;
          return aDistance.compareTo(bDistance);
        });
        break;
      case 'rating':
        _filteredEstablishments.sort((a, b) {
          final aRating = a.averageRating ?? 0.0;
          final bRating = b.averageRating ?? 0.0;
          return bRating.compareTo(aRating); // Maior rating primeiro
        });
        break;
      case 'price':
        _filteredEstablishments.sort((a, b) {
          final aPrice = a.startingPrice ?? double.infinity;
          final bPrice = b.startingPrice ?? double.infinity;
          return aPrice.compareTo(bPrice);
        });
        break;
    }
  }

  /// Recarrega os dados dos estabelecimen

  /// Verifica se um estabelecimento está aberto agora
  bool isEstablishmentOpen(Establishment establishment) {
    final now = TimeOfDay.now();

    int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

    final cur = toMinutes(now);
    final open = toMinutes(establishment.openingTime);
    final close = toMinutes(establishment.closingTime);

    if (open == close) return true;

    if (open < close) {
      return cur >= open && cur < close;
    } else {
      return cur >= open || cur < close;
    }
  }

  /// Filtra apenas estabelecimentos abertos
  void filterOpenEstablishments() {
    _filteredEstablishments = _filteredEstablishments
        .where((establishment) => isEstablishmentOpen(establishment))
        .toList();
    notifyListeners();
  }

  /// Remove filtro de estabelecimentos abertos
  void clearOpenFilter() {
    _applyFilters();
  }

  /// Toggle do filtro de estabelecimentos favoritos
  void toggleFavoritesFilter() {
    final hasFavorites = _originalEstablishments.any((e) => e.isFavorite == true);
    
    if (hasFavorites) {
      final currentlyShowingFavorites = _filteredEstablishments
          .every((e) => e.isFavorite == true);
          
      if (currentlyShowingFavorites) {
        // Se está mostrando só favoritos, volta para todos
        _applyFilters();
      } else {
        // Filtra só favoritos
        _filteredEstablishments = _filteredEstablishments
            .where((e) => e.isFavorite == true)
            .toList();
        notifyListeners();
      }
    }
  }

  /// Retorna as opções de ordenação disponíveis
  List<Map<String, String>> get sortOptions => [
    {'value': 'name', 'label': 'Nome'},
    {'value': 'distance', 'label': 'Distância'},
    {'value': 'rating', 'label': 'Avaliação'},
    {'value': 'price', 'label': 'Preço'},
  ];

  /// Retorna estatísticas dos estabelecimentos filtrados
  Map<String, dynamic> get statistics => {
    'total': _filteredEstablishments.length,
    'open': _filteredEstablishments.where((e) => isEstablishmentOpen(e)).length,
    'favorites': _filteredEstablishments.where((e) => e.isFavorite == true).length,
    'averageRating': _filteredEstablishments.isNotEmpty
        ? _filteredEstablishments
            .where((e) => e.averageRating != null)
            .map((e) => e.averageRating!)
            .fold(0.0, (a, b) => a + b) / 
          _filteredEstablishments.where((e) => e.averageRating != null).length
        : 0.0,
  };
}