// lib/core/http/authenticated_http_client.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/auth_service.dart';
import '../constants/api_config.dart';

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final AuthService _authService;

  AuthenticatedHttpClient({
    http.Client? innerClient,
    AuthService? authService,
  })  : _inner = innerClient ?? http.Client(),
        _authService = authService ?? AuthService();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.headers.addAll(ApiConfig.defaultHeaders);
    
    final authHeaders = _authService.authHeader;
    if (authHeaders.isNotEmpty) {
      request.headers.addAll(authHeaders);
    }

    try {
      final response = await _inner.send(request);
      
      if (response.statusCode == 401) {
        return await _handleUnauthorized(request);
      }
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.StreamedResponse> _handleUnauthorized(http.BaseRequest request) async {
    await _authService.logout();
    return await _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }

  // Métodos de conveniência

  Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final request = http.Request('GET', url);
    if (headers != null) request.headers.addAll(headers);
    
    final streamedResponse = await send(request).timeout(
      timeout ?? ApiConfig.defaultTimeout,
      onTimeout: () => throw TimeoutException('Request timeout', timeout),
    );
    
    return http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    final request = http.Request('POST', url);
    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List<int>) {
        request.bodyBytes = body;
      } else if (body is Map) {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      } else {
        throw ArgumentError('Invalid body type: ${body.runtimeType}');
      }
    }

    final streamedResponse = await send(request).timeout(
      timeout ?? ApiConfig.defaultTimeout,
      onTimeout: () => throw TimeoutException('Request timeout', timeout),
    );
    
    return http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    final request = http.Request('PUT', url);
    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List<int>) {
        request.bodyBytes = body;
      } else if (body is Map) {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      } else {
        throw ArgumentError('Invalid body type: ${body.runtimeType}');
      }
    }

    final streamedResponse = await send(request).timeout(
      timeout ?? ApiConfig.defaultTimeout,
      onTimeout: () => throw TimeoutException('Request timeout', timeout),
    );
    
    return http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    final request = http.Request('DELETE', url);
    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List<int>) {
        request.bodyBytes = body;
      } else if (body is Map) {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      } else {
        throw ArgumentError('Invalid body type: ${body.runtimeType}');
      }
    }

    final streamedResponse = await send(request).timeout(
      timeout ?? ApiConfig.defaultTimeout,
      onTimeout: () => throw TimeoutException('Request timeout', timeout),
    );
    
    return http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration? timeout,
  }) async {
    final request = http.Request('PATCH', url);
    if (headers != null) request.headers.addAll(headers);
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List<int>) {
        request.bodyBytes = body;
      } else if (body is Map) {
        request.body = jsonEncode(body);
        request.headers['Content-Type'] = 'application/json';
      } else {
        throw ArgumentError('Invalid body type: ${body.runtimeType}');
      }
    }

    final streamedResponse = await send(request).timeout(
      timeout ?? ApiConfig.defaultTimeout,
      onTimeout: () => throw TimeoutException('Request timeout', timeout),
    );
    
    return http.Response.fromStream(streamedResponse);
  }
}

class TimeoutException implements Exception {
  final String message;
  final Duration? timeout;

  const TimeoutException(this.message, this.timeout);

  @override
  String toString() {
    return 'TimeoutException: $message${timeout != null ? ' (${timeout!.inSeconds}s)' : ''}';
  }
}
