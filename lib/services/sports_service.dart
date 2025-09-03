import 'dart:convert';

import 'package:sporthub/core/constants/api_config.dart';
import 'package:sporthub/core/http/http_client_manager.dart';
import 'package:sporthub/models/sport.dart';

class SportsService {
  static final SportsService _instance = SportsService._internal();
  factory SportsService() => _instance;
  SportsService._internal();

  final _httpClient = HttpClientManager().client;

  // TODO: [Facilidade: 2, Prioridade: 2] - Implementar cache local para esportes
  // TODO: [Facilidade: 3, Prioridade: 3] - Adicionar filtros por categoria de esporte

  Future<List<Sport>> getAllSports() async {
    // TODO: [Facilidade: 2, Prioridade: 4] - Implementar timeout configurável
    // TODO: [Facilidade: 2, Prioridade: 3] - Adicionar retry automático em falhas de rede
    try{
      final response = await _httpClient.get(Uri.parse(ApiConfig.getSportsEndpoint));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> sportsData = responseData['sports'];
        return sportsData.map((item) => Sport.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load sports');
      }
    } catch (e) {
      throw Exception('Failed to load sports: $e');
    }
  }
}