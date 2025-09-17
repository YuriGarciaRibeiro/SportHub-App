import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sporthub/core/app_export.dart';

class LocationWeatherService {
  static const String _weatherApiKey = 'YOUR_OPENWEATHER_API_KEY'; // Configure sua API key
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';


  /// Verifica se o serviço de localização está habilitado
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      debugPrint('🌍 LOCATION_ERROR: $e');
      return false;
    }
  }

  /// Verifica e solicita permissões de localização
  Future<LocationPermission> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      return permission;
    } catch (e) {
      debugPrint('🌍 LOCATION_ERROR: $e');
      return LocationPermission.denied;
    }
  }

  /// Obtém a posição atual do dispositivo com múltiplas estratégias
  Future<Position?> getCurrentPosition({Duration? timeLimit}) async {
    final timeout = timeLimit ?? const Duration(seconds: 15);
    
    try {
      // Verifica se o serviço está habilitado
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('🌍 LOCATION_ERROR: Serviço de localização desabilitado');
        return null;
      }

      // Verifica permissões
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        debugPrint('🌍 LOCATION_ERROR: Permissão de localização negada');
        return null;
      }

      debugPrint('🌍 LOCATION_INFO: Obtendo posição com timeout de ${timeout.inSeconds}s');

      // Estratégia 1: Tenta última posição conhecida primeiro (muito rápido)
      try {
        Position? lastPosition = await Geolocator.getLastKnownPosition(
          forceAndroidLocationManager: false,
        );
        if (lastPosition != null) {
          // Verifica se a posição não é muito antiga (máx 30 minutos)
          final now = DateTime.now();
          final positionTime = lastPosition.timestamp;
          final difference = now.difference(positionTime).inMinutes;
          
          if (difference <= 30) {
            debugPrint('🌍 LOCATION_SUCCESS: Usando última posição conhecida (${difference}min atrás)');
            return lastPosition;
          }
        }
      } catch (e) {
        debugPrint('🌍 LOCATION_WARNING: Última posição não disponível: $e');
      }

      // Estratégia 2: Obtém posição atual com baixa precisão primeiro (mais rápido)
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low, // Muito mais rápido
          timeLimit: Duration(seconds: (timeout.inSeconds * 0.6).round()), // 60% do timeout
        );
        debugPrint('🌍 LOCATION_SUCCESS: Posição obtida com baixa precisão: ${position.latitude}, ${position.longitude}');
        return position;
      } catch (e) {
        debugPrint('🌍 LOCATION_WARNING: Baixa precisão falhou: $e');
      }

      // Estratégia 3: Tenta com precisão média como último recurso
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: (timeout.inSeconds * 0.4).round()), // Resto do timeout
      );

      debugPrint('🌍 LOCATION_SUCCESS: Posição obtida com precisão média: ${position.latitude}, ${position.longitude}');
      return position;
      
    } catch (e) {
      debugPrint('🌍 LOCATION_ERROR: Todas as estratégias falharam: $e');
      return null;
    }
  }

  /// Converte coordenadas em endereço
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    debugPrint('🌍 GEOCODING_START: Iniciando conversão de coordenadas');
    final startTime = DateTime.now();
    
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.subAdministrativeArea ?? place.locality ?? 'Cidade';
        String state = place.administrativeArea ?? 'Estado';
        final result = '$city, $state';
        final endTime = DateTime.now();
        debugPrint('🌍 GEOCODING_SUCCESS: Endereço obtido em ${endTime.difference(startTime).inMilliseconds}ms: $result');
        return result;
      }
      
      final endTime = DateTime.now();
      debugPrint('🌍 GEOCODING_WARNING: Nenhum resultado em ${endTime.difference(startTime).inMilliseconds}ms');
      return 'Localização não encontrada';
    } catch (e) {
      final endTime = DateTime.now();
      debugPrint('🌍 GEOCODING_ERROR: Erro em ${endTime.difference(startTime).inMilliseconds}ms: $e');
      return 'Erro na localização';
    }
  }

  /// Obtém informações do clima para as coordenadas fornecidas
  Future<String> getWeatherForCoordinates(double latitude, double longitude) async {
    debugPrint('🌤️ WEATHER_START: Iniciando obtenção de clima');
    final startTime = DateTime.now();
    
    try {
      // Verifica se a API key está configurada
      if (_weatherApiKey == 'YOUR_OPENWEATHER_API_KEY') {
        final endTime = DateTime.now();
        debugPrint('🌤️ WEATHER_MOCK: Usando valor padrão em ${endTime.difference(startTime).inMilliseconds}ms');
        return '25°C'; // Valor padrão quando API não configurada
      }

      final url = Uri.parse(
        '$_weatherBaseUrl/weather?lat=$latitude&lon=$longitude&appid=$_weatherApiKey&units=metric&lang=pt_br'
      );

      debugPrint('🌤️ WEATHER_REQUEST: Fazendo requisição para API');
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperature = data['main']['temp'].round();
        final result = '$temperature°C';
        final endTime = DateTime.now();
        debugPrint('🌤️ WEATHER_SUCCESS: Clima obtido em ${endTime.difference(startTime).inMilliseconds}ms: $result');
        return result;
      } else {
        final endTime = DateTime.now();
        debugPrint('🌤️ WEATHER_ERROR: Status ${response.statusCode} em ${endTime.difference(startTime).inMilliseconds}ms');
        return '25°C'; // Valor padrão em caso de erro
      }
    } catch (e) {
      final endTime = DateTime.now();
      debugPrint('�️ WEATHER_ERROR: Erro em ${endTime.difference(startTime).inMilliseconds}ms: $e');
      return '25°C'; // Valor padrão
    }
  }

  /// Obtém localização e clima atuais
  Future<Map<String, String>> getCurrentLocationAndWeather() async {
    try {
      Position? position = await getCurrentPosition();
      
      if (position != null) {
        final locationFuture = getAddressFromCoordinates(
          position.latitude, 
          position.longitude
        );
        final weatherFuture = getWeatherForCoordinates(
          position.latitude, 
          position.longitude
        );

        final results = await Future.wait([locationFuture, weatherFuture]);
        
        return {
          'location': results[0],
          'weather': results[1],
        };
      } else {
        debugPrint('🌍 LOCATION_FALLBACK: Usando localização fallback');
        return {
          'location': 'São Paulo, SP',
          'weather': '25°C',
        };
      }
    } catch (e) {
      debugPrint('🌍 LOCATION_ERROR: $e');
      return {
        'location': 'São Paulo, SP',
        'weather': '25°C',
      };
    }
  }

  Future<Map<String, String>> getLocationAndWeatherForCoordinates(
    double latitude, 
    double longitude
  ) async {
    try {
      final locationFuture = getAddressFromCoordinates(latitude, longitude);
      final weatherFuture = getWeatherForCoordinates(latitude, longitude);

      final results = await Future.wait([locationFuture, weatherFuture]);
      
      return {
        'location': results[0],
        'weather': results[1],
      };
    } catch (e) {
      return {
        'location': 'Localização desconhecida',
        'weather': '25°C',
      };
    }
  }

  /// Coordenadas de teste para diferentes cidades
  static const Map<String, Map<String, double>> testCoordinates = {
    'sao_paulo': {'lat': -23.5505, 'lng': -46.6333},
    'rio_de_janeiro': {'lat': -22.9068, 'lng': -43.1729},
    'brasilia': {'lat': -15.7940, 'lng': -47.8822},
    'san_francisco': {'lat': 37.7749, 'lng': -122.4194},
  };
}
