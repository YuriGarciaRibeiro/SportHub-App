import 'package:flutter/foundation.dart';
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
    _isLoading = true;
    notifyListeners();
    var position = await _locationWeatherService.getCurrentPosition();

    if (_nearbyEstablishments.isEmpty) {
      await executeOperation(() async {
        await Future.wait([
          _loadUserData(),
          _loadNearbyEstablishments(
            position!.latitude,
            position.longitude,
            20.0,
          ),
          _loadTopRatedEstablishments(
            position.latitude,
            position.longitude,
            20.0,
          ),
          _loadPopularSports(),
          _loadLocationAndWeather(),
          _loadUpcomingReservations(),
        ]);
        _isInitialized = true;
      });
    } else {
      await Future.wait([
        _loadUserData(),
        _loadNearbyEstablishments(
          position!.latitude,
          position.longitude,
          20.0,
        ),
        _loadTopRatedEstablishments(
          position.latitude,
          position.longitude,
          20.0,
        ),
        _loadPopularSports(),
        _loadLocationAndWeather(),
        _loadUpcomingReservations(),
      ]);
      _isInitialized = true;
    }

    _isLoading = false;
    notifyListeners();
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
    try {
      _isLocationEnabled = await _locationWeatherService.isLocationServiceEnabled();
      
      if (_isLocationEnabled) {
        final position = await _locationWeatherService.getCurrentPosition();
        if (position != null) {
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
        } else {
          _currentLocation = 'Localização indisponível';
          _currentWeather = '';
        }
      } else {
        _currentLocation = 'Localização desabilitada';
        _currentWeather = '';
      }
    } catch (e) {
      // TODO: 47 [Facilidade: 4, Prioridade: 3] - Implementar retry automático para serviços de localização
      // TODO: 48 [Facilidade: 3, Prioridade: 2] - Adicionar cache de última localização conhecida
      _currentLocation = 'Erro ao obter localização';
      _currentWeather = '';
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
