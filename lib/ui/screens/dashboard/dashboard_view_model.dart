import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sporthub/models/reservation.dart';
import 'package:sporthub/services/reservation_service.dart';
import '../../../../../models/establishment.dart';
import '../../../../../models/sport.dart';
import '../../../../../services/establishment_service.dart';
import '../../../../../services/sports_service.dart';
import '../../../../../services/auth_service.dart';
import '../../../../../services/location_weather_service.dart';
import '../../../../../core/base_view_model.dart';

class DashboardViewModel extends BaseViewModel {
  final EstablishmentService _establishmentService = EstablishmentService();
  final SportsService _sportsService = SportsService();
  final AuthService _authService = AuthService();
  final LocationWeatherService _locationWeatherService = LocationWeatherService();
  final ReservationService _reservationService = ReservationService();

  List<Establishment> _nearbyEstablishments = [];
  List<Establishment> _topRatedEstablishments = [];
  List<Establishment> _topFiveNearbyEstablishments = [];
  List<Establishment> _topFiveRatedEstablishments = [];
  List<Sport> _popularSports = [];
  List<Reservation> _upcomingReservations = [];
  String _userName = 'Usuário';
  String _currentLocation = 'Carregando...';
  String _currentWeather = '';
  bool _isLocationEnabled = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  List<Establishment> get nearbyEstablishments => _nearbyEstablishments;
  List<Establishment> get topRatedEstablishments => _topRatedEstablishments;
  List<Establishment> get topFiveNearbyEstablishments => _topFiveNearbyEstablishments;
  List<Establishment> get topFiveRatedEstablishments => _topFiveRatedEstablishments;
  List<Sport> get popularSports => _popularSports;
  List<Reservation> get upcomingReservations => _upcomingReservations;
  String get userName => _userName;
  String get currentLocation => _currentLocation;
  String get currentWeather => _currentWeather;
  bool get isLocationEnabled => _isLocationEnabled;
  @override
  bool get isLoading => _isLoading;

  Future<void> initializeDashboard() async {
    if (_isInitialized && _nearbyEstablishments.isNotEmpty) {
      return;
    }

    await executeOperation(() async {
      // Inicia operações independentes em paralelo (mais rápidas)
      final independentOperations = Future.wait([
        _loadUserData(),
        _loadPopularSports(),
        _loadUpcomingReservations(),
      ]);

      // Tenta obter localização com timeout menor
      Position? position;
      try {
        position = await _locationWeatherService.getCurrentPosition(
          timeLimit: const Duration(seconds: 6), // Timeout mais agressivo para primeira carga
        );
      } catch (e) {
        // Fallback: usa localização padrão de São Paulo
        position = null;
      }

      // Operações dependentes de localização
      late Future<void> locationDependentOperations;
      if (position != null) {
        locationDependentOperations = Future.wait([
          _loadNearbyEstablishments(position.latitude, position.longitude, 20.0),
          _loadTopRatedEstablishments(position.latitude, position.longitude, 20.0),
          _loadLocationAndWeatherWithPosition(position),
        ]);
      } else {
        // Fallback para São Paulo (-23.5505, -46.6333) - dados mais genéricos
        locationDependentOperations = Future.wait([
          _loadNearbyEstablishments(-23.5505, -46.6333, 20.0),
          _loadTopRatedEstablishments(-23.5505, -46.6333, 20.0),
          _loadLocationAndWeatherFallback(),
        ]);
      }

      // Aguarda todas as operações
      await Future.wait([
        independentOperations,
        locationDependentOperations,
      ]);

      _isInitialized = true;
    });
  }

  Future<void> _loadUpcomingReservations() async {
    try {
      final reservations = await _reservationService.getUserReservations();
      final now = DateTime.now();
      _upcomingReservations = reservations
          .where((r) => r.startTime.isAfter(now))
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      if (_upcomingReservations.length > 3) {
        _upcomingReservations = _upcomingReservations.take(3).toList();
      }
    } catch (e) {
      _upcomingReservations = [];
    }
    notifyListeners();
  }

  Future<void> _loadUserData() async {
    try {
      _userName = _authService.currentUserName ?? 'Usuário';
    } catch (e) {
      _userName = 'Usuário';
    }
    notifyListeners();
  }

  Future<void> _loadNearbyEstablishments(double latitude, double longitude, double radiusKm) async {
    try {
      final allEstablishments = await _establishmentService.getNearbyEstablishments(latitude, longitude, radiusKm);
      _nearbyEstablishments = allEstablishments.toList();
      _topFiveNearbyEstablishments = allEstablishments.take(5).toList();
    } catch (e) {
      _nearbyEstablishments = [];
    }
    notifyListeners();
  }

  Future<void> _loadTopRatedEstablishments(double latitude, double longitude, double radiusKm) async {
    try {
      final allEstablishments = await _establishmentService.getTopRatedEstablishments(latitude, longitude, radiusKm);
      _topRatedEstablishments = allEstablishments.toList();
      _topFiveRatedEstablishments = allEstablishments.take(5).toList();
    } catch (e) {
      _topRatedEstablishments = [];
    }
    notifyListeners();
  }

  Future<void> _loadPopularSports() async {
    try {
      final allSports = await _sportsService.getAllSports();
      _popularSports = allSports.take(6).toList();
    } catch (e) {
      _popularSports = [];
    }
    notifyListeners();
  }

  Future<void> _loadLocationAndWeather() async {
    // Este método não deveria ser chamado no novo fluxo
    // Usando fallback direto para evitar chamadas duplicadas de localização
    await _loadLocationAndWeatherFallback();
  }

  Future<void> _loadLocationAndWeatherWithPosition(Position position) async {
    try {
      _isLocationEnabled = true;
      
      final address = await _locationWeatherService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
      _currentLocation = address;
      
      final weather = await _locationWeatherService.getWeatherForCoordinates(
        position.latitude,
        position.longitude,
      );
      _currentWeather = weather;
    } catch (e) {
      _currentLocation = 'Erro ao obter localização';
      _currentWeather = '';
    }
    notifyListeners();
  }

  Future<void> _loadLocationAndWeatherFallback() async {
    try {
      _isLocationEnabled = await _locationWeatherService.isLocationServiceEnabled();
      _currentLocation = _isLocationEnabled ? 'São Paulo, SP' : 'Localização desabilitada';
      _currentWeather = '25°C';
    } catch (e) {
      _currentLocation = 'São Paulo, SP';
      _currentWeather = '25°C';
    }
    notifyListeners();
  }

  Future<void> refreshDashboard() async {
    _isLoading = true;
    notifyListeners();
    _isInitialized = false; // Força a reinicialização
    await initializeDashboard();
    // O loading será desativado dentro do initializeDashboard
  }

  void navigateToEstablishment(Establishment establishment) {
    debugPrint('Navegando para estabelecimento: ${establishment.name}');
  }

  void navigateToSportSearch(Sport sport) {
    debugPrint('Navegando para busca de esporte: ${sport.name}');
  }

  Future<void> requestLocationPermission() async {
    await executeOperation(() async {
      await _locationWeatherService.checkLocationPermission();
      await _loadLocationAndWeather();
    });
  }
}
