import 'dart:convert';

import 'package:sporthub/core/constants/api_config.dart';
import 'package:sporthub/core/http/http_client_manager.dart';
import 'package:sporthub/models/reservation.dart';

class ReservationService {
  static final ReservationService _instance = ReservationService._internal();
  factory ReservationService() => _instance;
  ReservationService._internal();

  final _httpClient = HttpClientManager().client;

  Future<List<Reservation>> getUserReservations() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.usersEndpoint}/reservations'),
      );
      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;
        return (data['items'] as List)
            .map((item) => Reservation.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> getUserReservationsWithPagination(
    String userId, {
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('${ApiConfig.reservationsEndpoint}/reservations?userId=$userId&page=$page&pageSize=$pageSize'),
      );
      if (response.statusCode == 200) {
        final String body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = json.decode(body) as Map<String, dynamic>;
        
        final reservations = (data['items'] as List)
            .map((item) => Reservation.fromJson(item))
            .toList();
        
        return {
          'reservations': reservations,
          'totalCount': data['totalCount'] ?? 0,
          'page': data['page'] ?? 1,
          'pageSize': data['pageSize'] ?? 10,
        };
      }
      return {
        'reservations': <Reservation>[],
        'totalCount': 0,
        'page': 1,
        'pageSize': 10,
      };
    } catch (e) {
      return {
        'reservations': <Reservation>[],
        'totalCount': 0,
        'page': 1,
        'pageSize': 10,
      };
    }
  }
}
