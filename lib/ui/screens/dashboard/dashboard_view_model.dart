import 'package:flutter/foundation.dart';
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

  List<Establishment> _nearbyEstablishments = [];
  List<Establishment> _topRatedEstablishments = [];
  List<Sport> _popularSports = [];
  String _userName = 'Usuário';
  String _currentLocation = 'Carregando...';
  String _currentWeather = '';
  bool _isLocationEnabled = false;
  bool _isInitialized = false;

  List<Establishment> get nearbyEstablishments => _nearbyEstablishments;
  List<Establishment> get topRatedEstablishments => _topRatedEstablishments;
  List<Sport> get popularSports => _popularSports;
  String get userName => _userName;
  String get currentLocation => _currentLocation;
  String get currentWeather => _currentWeather;
  bool get isLocationEnabled => _isLocationEnabled;

  Future<void> initializeDashboard() async {
    // Se já foi inicializado e temos dados, não precisa recarregar
    if (_isInitialized && _nearbyEstablishments.isNotEmpty) {
      return;
    }
    var position = await _locationWeatherService.getCurrentPosition();
    // Se não tem dados ainda, carrega com loading
    if (_nearbyEstablishments.isEmpty) {
      await executeOperation(() async {
        await Future.wait([
          _loadUserData(),
          _loadNearbyEstablishments(
            position!.latitude,
            position.longitude,
            100000000.0,
          ),
          _loadTopRatedEstablishments(),
          _loadPopularSports(),
          _loadLocationAndWeather(),
        ]);
        _isInitialized = true;
      });
    } else {
      await Future.wait([
        _loadUserData(),
        _loadNearbyEstablishments(
          position!.latitude,
          position.longitude,
          100000000.0,
        ),
        _loadTopRatedEstablishments(),
        _loadPopularSports(),
        _loadLocationAndWeather(),
      ]);
      _isInitialized = true;
    }
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
      _nearbyEstablishments = allEstablishments.take(5).toList();
    } catch (e) {
      _nearbyEstablishments = [];
    }
    notifyListeners();
  }

  Future<void> _loadTopRatedEstablishments() async {
    try {
      final allEstablishments = await _establishmentService.getAllEstablishments();
      _topRatedEstablishments = allEstablishments.take(3).toList();
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
    _isInitialized = false; // Força a reinicialização
    await initializeDashboard();
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
