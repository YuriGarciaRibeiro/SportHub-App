import 'package:flutter/foundation.dart';
import 'package:sporthub/models/reservation.dart';
import 'package:sporthub/services/reservation_service.dart';
import '../../../../../core/base_view_model.dart';



class ReservationsViewModel extends BaseViewModel {
  final ReservationService _reservationService = ReservationService();

  List<Reservation> _allReservations = [];
  List<Reservation> _filteredReservations = [];
  String _selectedFilter = 'all';
  bool _isInitialized = false;
  bool _isLoading = false;

  @override
  bool get isLoading => _isLoading;

  List<Reservation> get filteredReservations => _filteredReservations;
  String get selectedFilter => _selectedFilter;

  Future<void> initializeReservations() async {
    debugPrint('Inicializando reservas...');
    if (_isInitialized && _allReservations.isNotEmpty) {
      return;
    }

    if (_allReservations.isEmpty) {
      await executeOperation(() async {
        _isLoading = true;
        await _loadReservations();
        _applyFilter();
        _isInitialized = true;
        _isLoading = false;
      });
    } else {
      await _loadReservations();
      _applyFilter();
      _isInitialized = true;
    }
  }

  Future<void> _loadReservations() async {
    try {
      final reservations = await _reservationService.getUserReservations();
      _allReservations = reservations;
      _applyFilter();
    } catch (e) {
      _allReservations = [];
      _applyFilter();
    }
    notifyListeners();
  
  }

  void updateFilter(String filter) {
    _selectedFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  /// Aplica filtro selecionado
  void _applyFilter() {
    final now = DateTime.now();
    
    switch (_selectedFilter) {
      case 'upcoming':
        _filteredReservations = _allReservations
            .where((reservation) => reservation.startTime.isAfter(now))
            .toList();
        break;
      case 'past':
        _filteredReservations = _allReservations
            .where((reservation) => reservation.endTime.isBefore(now))
            .toList();
        break;
      case 'all':
      default:
        _filteredReservations = List.from(_allReservations);
        break;
    }

    if (_selectedFilter == 'past') {
      _filteredReservations.sort((a, b) => b.endTime.compareTo(a.endTime));
    } else {
      _filteredReservations.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    await executeOperation(() async {
      // Simula delay de cancelamento
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Remove a reserva da lista
      _allReservations.removeWhere((r) => r.id == reservationId);
      _applyFilter();
    });
  }

  Future<void> refreshReservations() async {
    _isInitialized = false; // Força a reinicialização
    await initializeReservations();
  }

  void navigateToReservationDetails(Reservation reservation) {
    debugPrint('Navegando para detalhes da reserva: ${reservation.id}');
  }

  void navigateToEstablishment(Reservation reservation) {
    debugPrint('Navegando para estabelecimento: ${reservation.establishmentName}');
  }

  Map<String, int> getReservationStats() {
    final now = DateTime.now();
    return {
      'total': _allReservations.length,
      'upcoming': _allReservations
          .where((r) => r.startTime.isAfter(now))
          .length,
      'past': _allReservations
          .where((r) => r.endTime.isBefore(now))
          .length,
    };
  }
}
