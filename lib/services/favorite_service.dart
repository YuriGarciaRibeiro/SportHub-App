import 'dart:convert';

import 'package:sporthub/core/constants/api_config.dart';
import 'package:sporthub/core/http/http_client_manager.dart';

class FavoriteService {
  static final FavoriteService _instance = FavoriteService._internal();
  factory FavoriteService() => _instance;
  FavoriteService._internal();

  final _httpClient = HttpClientManager().client;

  Future<bool> addFavorite(int entityType, String entityId) async {
    try {
      final response = await _httpClient.post(
        Uri.parse(ApiConfig.favoritesEndpoint),
        body: jsonEncode({
          'entityType': entityType,
          'entityId': entityId,
        }),
      );

      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFavorite(int entityType, String entityId) async {
    try {
      final response = await _httpClient.delete(
        Uri.parse('${ApiConfig.favoritesEndpoint}/$entityType/$entityId'),
      );

      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}