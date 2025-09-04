import 'dart:convert';
import '../core/constants/api_config.dart';
import '../core/http/http_client_manager.dart';
import '../models/establishment.dart';

class EstablishmentService {
  static final EstablishmentService _instance = EstablishmentService._internal();
  factory EstablishmentService() => _instance;
  EstablishmentService._internal();

  final _httpClient = HttpClientManager().client;

  // TODO: [Facilidade: 3, Prioridade: 3] - Implementar paginação para lista de estabelecimentos
  // TODO: [Facilidade: 3, Prioridade: 2] - Adicionar cache local com TTL configurável
  // TODO: [Facilidade: 4, Prioridade: 3] - Implementar filtros avançados (distância, preço, avaliação)
  Future<List<Establishment>> getAllEstablishments() async {
    try {
      final response = await _httpClient.get(
        Uri.parse(ApiConfig.EstablishmentsEndpoint),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> items = responseData['items'] ?? [];
        return items.map((dto) => Establishment.fromDto(dto)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<Establishment?> getEstablishmentById(String id) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.EstablishmentsEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;
        return Establishment.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Establishment>> getEstablishmentsBySport(String sportId) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/establishments?sportId=$sportId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Establishment.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos por esporte: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<Establishment>> getNearbyEstablishments(double latitude, double longitude, double radiusKm) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.EstablishmentsEndpoint}?latitude=$latitude&longitude=$longitude&radiusKm=$radiusKm&orderBy=1&sortDirection=1'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return (data['items'] as List<dynamic>).map((json) => Establishment.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos próximos: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  // TODO: [Facilidade: 3, Prioridade: 4] - Implementar busca por localização/coordenadas
  // TODO: [Facilidade: 2, Prioridade: 4] - Implementar busca por texto/nome
  // TODO: [Facilidade: 3, Prioridade: 5] - Implementar método para obter horários disponíveis
}
