import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationWeatherService {
  // TODO: [Facilidade: 2, Prioridade: 5] - Configurar API key via variáveis de ambiente
  static const String _weatherApiKey = 'YOUR_OPENWEATHER_API_KEY'; // Configure sua API key
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  // TODO: [Facilidade: 2, Prioridade: 2] - Implementar cache de clima com TTL
  // TODO: [Facilidade: 3, Prioridade: 3] - Adicionar previsão do tempo para próximos dias

  /// Verifica se o serviço de localização está habilitado
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
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
      return LocationPermission.denied;
    }
  }

  /// Obtém a posição atual do dispositivo
  Future<Position?> getCurrentPosition() async {
    try {
      // Verifica se o serviço está habilitado
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      // Verifica permissões
      LocationPermission permission = await checkLocationPermission();
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Obtém a posição com configurações básicas
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      return position;
    } catch (e) {
      return null;
    }
  }

  /// Converte coordenadas em endereço
  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String city = place.subAdministrativeArea ?? place.locality ?? 'Cidade';
        String state = place.administrativeArea ?? 'Estado';
        return '$city, $state';
      }
      
      return 'Localização não encontrada';
    } catch (e) {
      return 'Erro na localização';
    }
  }

  /// Obtém informações do clima para as coordenadas fornecidas
  Future<String> getWeatherForCoordinates(double latitude, double longitude) async {
    try {
      // Verifica se a API key está configurada
      if (_weatherApiKey == 'YOUR_OPENWEATHER_API_KEY') {
        return '25°C'; // Valor padrão quando API não configurada
      }

      final url = Uri.parse(
        '$_weatherBaseUrl/weather?lat=$latitude&lon=$longitude&appid=$_weatherApiKey&units=metric&lang=pt_br'
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temperature = data['main']['temp'].round();
        return '$temperature°C';
      } else {
        return '25°C'; // Valor padrão em caso de erro
      }
    } catch (e) {
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
        return {
          'location': 'São Paulo, SP',
          'weather': '25°C',
        };
      }
    } catch (e) {
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
