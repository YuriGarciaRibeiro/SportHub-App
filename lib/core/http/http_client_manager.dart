// lib/core/http/http_client_manager.dart
import 'authenticated_http_client.dart';
import '../../services/auth_service.dart';

class HttpClientManager {
  static final HttpClientManager _instance = HttpClientManager._internal();
  factory HttpClientManager() => _instance;
  HttpClientManager._internal();

  AuthenticatedHttpClient? _client;

  AuthenticatedHttpClient get client {
    _client ??= AuthenticatedHttpClient(
      authService: AuthService(),
    );
    return _client!;
  }

  void reset() {
    _client?.close();
    _client = null;
  }

  void dispose() {
    _client?.close();
    _client = null;
  }
}
