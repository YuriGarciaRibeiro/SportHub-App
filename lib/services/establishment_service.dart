import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants/api_config.dart';
import '../models/establishment.dart';

class EstablishmentService {
  static final EstablishmentService _instance = EstablishmentService._internal();
  factory EstablishmentService() => _instance;
  EstablishmentService._internal();

  // Buscar todos os estabelecimentos
  Future<List<Establishment>> getAllEstablishments() async {
    // TODO: Implementar paginação para lista de estabelecimentos
    // TODO: Adicionar cache local com TTL configurável
    // TODO: Implementar filtros avançados (distância, preço, avaliação)
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getEstablishmentsEndpoint),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

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

  // Buscar estabelecimento por ID
  Future<Establishment?> getEstablishmentById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getEstablishmentsEndpoint}/$id'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

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

  // Buscar estabelecimentos por esporte
  Future<List<Establishment>> getEstablishmentsBySport(String sportId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/v1/establishments?sportId=$sportId'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(ApiConfig.defaultTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Establishment.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar estabelecimentos por esporte: ${response.statusCode}');
      }
    } catch (e) {
      // Se não conseguir conectar com a API, retorna lista vazia
      return [];
    }
  }

  // TODO: Implementar busca por localização/coordenadas
  // TODO: Implementar busca por texto/nome
  // TODO: Implementar método para obter horários disponíveis
}
