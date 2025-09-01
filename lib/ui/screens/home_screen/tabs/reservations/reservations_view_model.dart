import 'package:flutter/foundation.dart';
import '../../../../../core/base_view_model.dart';

class Reservation {
  final String id;
  final String establishmentName;
  final String courtName;
  final DateTime date;
  final String timeSlot;
  final String status;
  final double price;
  final String sport;

  Reservation({
    required this.id,
    required this.establishmentName,
    required this.courtName,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.price,
    required this.sport,
  });
}

class ReservationsViewModel extends BaseViewModel {
  List<Reservation> _allReservations = [];
  List<Reservation> _filteredReservations = [];
  String _selectedFilter = 'all';
  bool _isInitialized = false;

  List<Reservation> get filteredReservations => _filteredReservations;
  String get selectedFilter => _selectedFilter;

  Future<void> initializeReservations() async {
    // Se já foi inicializado e temos dados, não precisa recarregar
    if (_isInitialized && _allReservations.isNotEmpty) {
      return;
    }

    // Se não tem dados ainda, carrega com loading
    if (_allReservations.isEmpty) {
      await executeOperation(() async {
        await _loadMockReservations();
        _applyFilter();
        _isInitialized = true;
      });
    } else {
      // Se já tem dados, só atualiza sem loading
      await _loadMockReservations();
      _applyFilter();
      _isInitialized = true;
    }
  }

  Future<void> _loadMockReservations() async {
    // TODO: Substituir dados mock por integração real com API
    // TODO: Implementar sincronização automática de reservas
    // TODO: Adicionar notificações para lembretes de reserva
    try {
      // Removido delay artificial para uma experiência mais fluida
      _allReservations = [
        Reservation(
          id: '1',
          establishmentName: 'Arena Sports',
          courtName: 'Quadra 1',
          date: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '14:00 - 15:00',
          status: 'confirmed',
          price: 80.0,
          sport: 'Futebol',
        ),
        Reservation(
          id: '2',
          establishmentName: 'Centro Esportivo Elite',
          courtName: 'Quadra 2',
          date: DateTime.now().add(const Duration(days: 5)),
          timeSlot: '18:00 - 19:00',
          status: 'pending',
          price: 120.0,
          sport: 'Tênis',
        ),
        Reservation(
          id: '3',
          establishmentName: 'Sports Complex',
          courtName: 'Quadra A',
          date: DateTime.now().subtract(const Duration(days: 3)),
          timeSlot: '16:00 - 17:00',
          status: 'confirmed',
          price: 90.0,
          sport: 'Basquete',
        ),
        Reservation(
          id: '4',
          establishmentName: 'Arena Municipal',
          courtName: 'Quadra 3',
          date: DateTime.now().subtract(const Duration(days: 1)),
          timeSlot: '20:00 - 21:00',
          status: 'cancelled',
          price: 70.0,
          sport: 'Vôlei',
        ),
      ];
    } catch (e) {
      _allReservations = [];
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
            .where((reservation) => 
                reservation.date.isAfter(now) && 
                reservation.status != 'cancelled')
            .toList();
        break;
      case 'past':
        _filteredReservations = _allReservations
            .where((reservation) => 
                reservation.date.isBefore(now) && 
                reservation.status != 'cancelled')
            .toList();
        break;
      case 'cancelled':
        _filteredReservations = _allReservations
            .where((reservation) => reservation.status == 'cancelled')
            .toList();
        break;
      case 'all':
      default:
        _filteredReservations = List.from(_allReservations);
        break;
    }

    if (_selectedFilter == 'past') {
      _filteredReservations.sort((a, b) => b.date.compareTo(a.date));
    } else {
      _filteredReservations.sort((a, b) => a.date.compareTo(b.date));
    }
  }

  Future<void> cancelReservation(String reservationId) async {
    await executeOperation(() async {
      // Simula delay de cancelamento
      await Future.delayed(const Duration(milliseconds: 800));
      
      final index = _allReservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        final reservation = _allReservations[index];
        _allReservations[index] = Reservation(
          id: reservation.id,
          establishmentName: reservation.establishmentName,
          courtName: reservation.courtName,
          date: reservation.date,
          timeSlot: reservation.timeSlot,
          status: 'cancelled',
          price: reservation.price,
          sport: reservation.sport,
        );
        _applyFilter();
      }
    });
  }

  Future<void> confirmReservation(String reservationId) async {
    await executeOperation(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      
      final index = _allReservations.indexWhere((r) => r.id == reservationId);
      if (index != -1) {
        final reservation = _allReservations[index];
        _allReservations[index] = Reservation(
          id: reservation.id,
          establishmentName: reservation.establishmentName,
          courtName: reservation.courtName,
          date: reservation.date,
          timeSlot: reservation.timeSlot,
          status: 'confirmed',
          price: reservation.price,
          sport: reservation.sport,
        );
        _applyFilter();
      }
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
          .where((r) => r.date.isAfter(now) && r.status != 'cancelled')
          .length,
      'past': _allReservations
          .where((r) => r.date.isBefore(now) && r.status != 'cancelled')
          .length,
      'cancelled': _allReservations
          .where((r) => r.status == 'cancelled')
          .length,
    };
  }
}
